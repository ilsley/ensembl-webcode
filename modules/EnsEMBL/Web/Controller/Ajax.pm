=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Controller::Ajax;

use strict;

use Apache2::RequestUtil;
use HTML::Entities  qw(decode_entities);
use JSON            qw(from_json);
use List::MoreUtils qw(firstidx);
use URI::Escape     qw(uri_unescape);

use EnsEMBL::Web::DBSQL::WebsiteAdaptor;
use EnsEMBL::Web::Hub;

use base qw(EnsEMBL::Web::Controller);

sub new {
  my $class = shift;
  my $r     = shift || Apache2::RequestUtil->can('request') ? Apache2::RequestUtil->request : undef;
  my $args  = shift || {};
  my $self  = {};
  
  my $hub = EnsEMBL::Web::Hub->new({
    apache_handle  => $r,
    session_cookie => $args->{'session_cookie'},
    user_cookie    => $args->{'user_cookie'},
  });
  
  my $func = $hub->action;
  
  bless $self, $class;
  
  $self->$func($hub) if $self->can($func);
  
  return $self;
}

sub autocomplete {
  my ($self, $hub) = @_;
  my $cache   = $hub->cache;
  my $species = $hub->species;
  my $query   = $hub->param('q');
  my ($key, $results);
  
  if ($cache) {
    $key     = sprintf '::AUTOCOMPLETE::GENE::%s::%s::', $hub->species, $query;
    $results = $cache->get($key);
  }
  
  if (!$results) {
    my $dbh = EnsEMBL::Web::DBSQL::WebsiteAdaptor->new($hub)->db;
    my $sth = $dbh->prepare(sprintf 'select display_label, stable_id, db from gene_autocomplete where species = "%s" and display_label like %s', $species, $dbh->quote("$query%"));
    
    $sth->execute;
    
    $results = $sth->fetchall_arrayref;
    $cache->set($key, $results, undef, 'AUTOCOMPLETE') if $cache;
  }
  
  print $self->jsonify($results);
}

sub track_order {
  my ($self, $hub) = @_;
  my $image_config = $hub->get_imageconfig($hub->param('image_config'));
  my $species      = $image_config->species;
  my $node         = $image_config->get_node('track_order');
  
  $node->set_user($species, { %{$node->get($species) || {}}, $hub->param('track') => $hub->param('order') });
  my $text = $node->data->{'name'} || $node->data->{'coption'};
  push @{$image_config->altered}, $text;
  $hub->session->store;
}

sub multi_species {
  my ($self, $hub) = @_;
  my %species = map { $_ => $hub->param($_) } $hub->param;
  my %args    = ( type => 'multi_species', code => 'multi_species' );
  my $session = $hub->session;
  
  if (scalar keys %species) {
    $session->set_data(%args, $hub->species => \%species);
  } else {
    my %data = %{$session->get_data(%args)};
    delete $data{$hub->species};
    
    $session->purge_data(%args);
    $session->set_data(%args, %data) if scalar grep $_ !~ /(type|code)/, keys %data;
  }
}

sub cell_type {
  my ($self,$hub) = @_;
  my $cell = $hub->param('cell');
  my $image_config_name = $hub->param('image_config') || 'regulation_view';

  my $image_config = $hub->get_imageconfig($image_config_name);
  my %cell;
  foreach my $cell (split(/,/,uri_unescape($hub->param('cell')))) {
    $cell{$image_config->tree->clean_id($cell)} = 1;
  }
  foreach my $type (qw(reg_features seg_features reg_feats_core reg_feats_non_core)) {
    my $menu = $image_config->get_node($type);
    next unless $menu;
    foreach my $node (@{$menu->child_nodes}) {
      my $cell = $node->id;
      unless($cell =~ s/^${type}_//) {
        $cell =~ s/^(reg_feats_|seg_)//;
      }
      my $renderer = $cell{$cell} ? 'normal' : 'off';
      if($type ne 'seg_features' or !$cell{$cell}) {
        $image_config->update_track_renderer($node->id,$renderer);
      }
    }
  }
  $hub->session->store;
}

sub evidence {
  my ($self,$hub) = @_;
  my $evidence = $hub->param('evidence');

  my %evidence = map { $_ => 1 } split(/,/,$hub->param('evidence'));
  foreach my $image_config_name (qw(regulation_view reg_summary_page)) {
    my $image_config = $hub->get_imageconfig($image_config_name);
    foreach my $type (qw(reg_feats_core reg_feats_non_core)) {
      my $menu = $image_config->get_node($type);
      next unless $menu;
      foreach my $node (@{$menu->child_nodes}) {
        my $ev = $node->id;
        my $cell = $node->id;
        $cell =~ s/^${type}_//;
        foreach my $node2 (@{$node->child_nodes}) {
          my $ev = $node2->id;
          $ev =~ s/^${type}_${cell}_//;
          my $renderer = $evidence{$ev} ? 'on' : 'off';
          $image_config->update_track_renderer($node2->id,$renderer);
        }
      }
    }
  }
  $hub->session->store;
}

sub reg_renderer {
  my ($self,$hub) = @_;

  my $renderer = $hub->input->url_param('renderer');
  my $state = $hub->param('state');

  my $mask = firstidx { $renderer eq $_ } qw(x peaks signals);
  my $image_config = $hub->get_imageconfig('regulation_view');
  foreach my $type (qw(reg_features seg_features reg_feats_core reg_feats_non_core)) {
    my $menu = $image_config->get_node($type);
    next unless $menu;
    foreach my $node (@{$menu->child_nodes}) {
      my $old = $node->get('display');
      my $renderer = firstidx { $old eq $_ }
        qw(off compact tiling tiling_feature);
      next if !$renderer;
      $renderer |= $mask if $state;
      $renderer &=~ $mask unless $state;
      $renderer = 1 unless $renderer;
      $renderer = [ qw(off compact tiling tiling_feature) ]->[$renderer];
      $image_config->update_track_renderer($node->id,$renderer);
    }
  }
  $hub->session->store;
  print $self->jsonify({
    reload_panels => ['FeaturesByCellLine'],
  });
}

sub nav_config {
  my ($self, $hub) = @_;
  my $session = $hub->session;
  my %args    = ( type => 'nav', code => $hub->param('code') );
  my %data    = %{$session->get_data(%args) || {}};
  my $menu    = $hub->param('menu');
  
  if ($hub->param('state')) {
    $data{$menu} = 1;
  } else {
    delete $data{$menu};
  }
  
  $session->purge_data(%args);
  $session->set_data(%args, %data) if scalar grep $_ !~ /(type|code)/, keys %data;
}

sub data_table_config {
  my ($self, $hub) = @_;
  my $session = $hub->session;
  my $sorting = $hub->param('sorting');
  my $hidden  = $hub->param('hidden_columns');
  my %args    = ( type => 'data_table', code => $hub->param('id') );
  my %data;
  
  $data{'sorting'}        = "[$sorting]" if length $sorting;
  $data{'hidden_columns'} = "[$hidden]"  if length $hidden;
  
  $session->purge_data(%args);
  $session->set_data(%args, %data) if scalar keys %data;
}

sub table_export {
  my ($self, $hub) = @_;
  my $r     = $hub->apache_handle;
  my $data  = from_json($hub->param('data'));
  my $clean = sub {
    my ($str,$opts) = @_;
    # Remove summaries, ugh.
    $str =~ s!<span class="toggle_summary[^"]*">.*?</span>!!g;
    # split multiline columns
    for (2..$opts->{'split_newline'}) {
      unless($str =~ s/<br.*?>/\0/) {
        $str =~ s/$/\0/;
      }
    }
    #
    $str =~ s/<br.*?>/ /g;
    $str =~ s/\xC2\xAD//g;     # Layout codepoint (shy hyphen)
    $str =~ s/\xE2\x80\x8B//g; # Layout codepoint (zero-width space)
    $str =~ s/\R//g;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//g;
    $str = $self->strip_HTML(decode_entities($str));
    $str =~ s/"/""/g; 
    $str =~ s/\0/","/g;
    return $str;
  };
  
  $r->content_type('application/octet-string');
  $r->headers_out->add('Content-Disposition' => sprintf 'attachment; filename=%s.csv', $hub->param('filename'));

  my $options = from_json($hub->param('expopts')) || (); 
  foreach my $row (@$data) {
    my @row_out;
    my @row_opts = @$options;
    foreach my $col (@$row) {
      my $opt = shift @row_opts;
      push @row_out,sprintf('"%s"',$clean->($col,$opt || {}));
    }
    print join(',',@row_out)."\n";
  }
}

1;
