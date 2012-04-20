package Bio::EnsEMBL::GlyphSet::structural_variation;

use strict;

use base qw(Bio::EnsEMBL::GlyphSet_simple);

sub my_label { return 'Structural variations'; }

sub features {
  my $self     = shift; 
  my $slice    = $self->{'container'};
  my $source   = $self->my_config('source');
  my $set_name = $self->my_config('set_name');
  my $var_features;
  
  # Structural variations by set
  if ($set_name) {
    $var_features = $slice->get_all_StructuralVariationFeatures_by_VariationSet($self->{'config'}->hub->get_adaptor('get_VariationSetAdaptor', 'variation')->fetch_by_name($set_name));
  } elsif ($source =~ /^\w/) {
    $var_features = $slice->get_all_StructuralVariationFeatures($source); # Structural variations by source
  }  else {
    $var_features = $slice->get_all_StructuralVariationFeatures; # All structural variations
  }
  
  if ($self->my_config('display') eq 'normal') {
    $self->get_render_normal;
  }
  
  return $var_features;  
}

sub colour_key  {
  my ($self, $f) = @_;
  return $f->class_SO_term;
}

sub tag {
  my ($self, $f) = @_;
  my $colour         = $self->my_colour($self->colour_key($f), 'tag');
  my $inner_crossing = $f->inner_start && $f->inner_end && $f->inner_start >= $f->inner_end ? 1 : 0;
  my @g_objects;

  if ($inner_crossing && $f->inner_start == $f->seq_region_end) {
    push @g_objects, {
        style  => 'rect',
        colour => $colour,
        start  => $f->start,
        end    => $f->end
     };
     return @g_objects;
  }

  # start of feature
  if ($f->outer_start && $f->inner_start) {
    if ($f->outer_start != $f->inner_start && !$inner_crossing) {
      push @g_objects, {
        style  => 'rect',
        colour => $colour,
        start  => $f->start,
        end    => $f->inner_start - $f->seq_region_start + $f->start
      };
    }
  } elsif ($f->outer_start) {
    if ($f->outer_start == $f->seq_region_start || $inner_crossing) {
      push @g_objects, {
        style  => 'bound_triangle_right',
        colour => $colour,
        start  => $f->start,
        out    => 1
      };
    }
  } elsif ($f->inner_start) {
    if ($f->inner_start == $f->seq_region_start && !$inner_crossing) {
      push @g_objects, {
        style  => 'bound_triangle_left',
        colour => $colour,
        start  => $f->start
      };
    }
  }
  
  # end of feature
  if ($f->outer_end && $f->inner_end) {
    if ($f->outer_end != $f->inner_end && !$inner_crossing) {
      push @g_objects, {
        style  => 'rect',
        colour => $colour,
        start  => $f->end - $f->seq_region_end + $f->inner_end,
        end    => $f->end
      };
    }
  } elsif ($f->outer_end) {
    if ($f->outer_end == $f->seq_region_end || $inner_crossing) {
      push @g_objects, {
        style  => 'bound_triangle_left',
        colour => $colour,
        start  => $f->end,
        out    => 1
      };
    }
  } elsif ($f->inner_end) {
    if ($f->inner_end == $f->seq_region_end && !$inner_crossing) {
      push @g_objects, {
        style  => 'bound_triangle_right',
        colour => $colour,
        start  => $f->end
      };
    }
  }
  
  return @g_objects;
} 


sub get_render_normal {
  my $self = shift;
  
  my ($font, $fontsize) = $self->get_font_details($self->my_config('font') || 'innertext');
  my $height            = $self->my_config('height') || [$self->get_text_width(0, 'X', '', font => $font, ptsize => $fontsize)]->[3] + 2;
  $self->{'extras'}{'height'} = $height/=2;
}


sub render_tag {
  my ($self, $tag, $composite, $slice_length, $width, $start, $end, $img_start, $img_end) = @_;
  my @glyph;
  
  if ($tag->{'style'} =~ /^bound_triangle_(\w+)$/ && $img_start < $tag->{'start'} && $img_end > $tag->{'end'}) {
    my $pix_per_bp = $self->scalex;
    my $x          = $tag->{'start'} + ($tag->{'out'} == ($1 eq 'left') ? 1 : -1) * ($tag->{'out'} ? $width  / 4 / $pix_per_bp : ($width + 2) / 2 / $pix_per_bp);
    my $y          = $width / 2;
    
    # Triangle returns an array: the triangle, and an invisible rectangle behind it for clicking purposes
    @glyph = $self->Triangle({
      mid_point    => [ $x, $y ],
      colour       => $tag->{'colour'},
      absolutey    => 1,
      width        => $width,
      height       => $y / $pix_per_bp,
      direction    => $1,
      bordercolour => 'dimgray',
    });
  }
  
  return @glyph;
}

sub href {
  my ($self, $f) = @_;
  
  return $self->_url({
    type => 'StructuralVariation',
    sv   => $f->variation_name,
    svf  => $f->dbID,
    vdb  => 'variation'
  });
}

sub title {
  my ($self, $f) = @_;
  my $id     = $f->variation_name;
  my $start  = $self->{'container'}->start + $f->start -1;
  my $end    = $self->{'container'}->end + $f->end;
  my $pos    = 'Chr ' . $f->seq_region_name . ":$start-$end";
  my $source = $f->source;

  return "Structural variation: $id; Source: $source; Location: $pos";
}

sub highlight {
  my ($self, $f, $composite, $pix_per_bp, $h) = @_;
  my $id = $f->variation_name;
  my %highlights;
  my $extra = 0;
  @highlights{$self->highlights} = (1);

  my $length = ($f->end - $f->start) + 1; 
  
  return unless $highlights{$id};
  
  # First a black box
  $self->unshift($self->Rect({
    x         => $composite->x - 2/$pix_per_bp,
    y         => $composite->y - 2, # + makes it go down
    width     => $composite->width + 4/$pix_per_bp,
    height    => $h + 4,
    colour    => 'green',
    absolutey => 1,
  }));
}

1;
