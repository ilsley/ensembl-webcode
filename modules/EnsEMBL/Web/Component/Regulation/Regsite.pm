=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2022] EMBL-European Bioinformatics Institute

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

package EnsEMBL::Web::Component::Regulation::Regsite;

use strict;
use warnings;
no warnings "uninitialized";

use EnsEMBL::Draw::Utils::ColourMap;
use EnsEMBL::Web::Utils::FormatText qw(helptip);

use base qw(EnsEMBL::Web::Component::Regulation);


sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(1);
  # $self->has_image(1);
}

sub content {
  my $self = shift;
  my $object = $self->object || $self->hub->core_object('regulation'); 
  my ($html, $Configs);

  my $context      = $self->param( 'context' ) || 200; 
  my $object_slice = $object->get_bound_context_slice($context);
     $object_slice = $object_slice->invert if $object_slice->strand < 1;

  
  $html .= '<h3>Summary of Regulatory Activity (for now)
              <a title="Click to show or hide the table" rel="celltype_regfeature_table" href="#" class="toggle_link toggle new_icon open _slide_toggle">Hide</a>
            </h3>';

  
  return $html;
}

1;
