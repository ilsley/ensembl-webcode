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

package EnsEMBL::Web::Component::Location::RegulationParams;

use strict;
use warnings;

# no warnings "uninitialized";

# use EnsEMBL::Draw::Utils::ColourMap;
# use EnsEMBL::Web::Utils::FormatText qw(helptip);

use parent qw(EnsEMBL::Web::Component::Location);


sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(1);
  # $self->has_image(1);
}

sub content {
  my $self = shift;
#   my $object = $self->object || $self->hub->core_object('regulation'); 
#   my ($html, $Configs);
  my $html;

  my $hub          = $self->hub;
  my $image_width  = $self->image_width . 'px';

  my $object = $self->hub->core_object('Location');
  my $region_length = $object->seq_region_length; # TODO: is this safe with no "if $object"?
  my $seq_region_name = $object->seq_region_name;
  my $seq_region_start = $object-> seq_region_start;
  my $seq_region_end = $object->seq_region_end;
  my $seq_region_strand = $object->seq_region_strand;
  my $seq_region_type = $object->seq_region_type;

  my $SD           = $hub->species_defs;
  my $release_id   = $SD->ENSEMBL_VERSION;
  my $display_name   = $SD->SPECIES_DISPLAY_NAME;
  my $assembly = $SD->ASSEMBLY_NAME;
  my $assembly_version = $SD->ASSEMBLY_VERSION;
  my $assembly_accession = $SD->ASSEMBLY_ACCESSION;
  my $species_group = $SD->SPECIES_GROUP;
  my $species = $SD->name;

  $html = qq(<script>
            var locdata = document.getElementById("locdata");
            locdata.innerHTML="Location: $seq_region_name: $seq_region_start - $seq_region_end"
          </script>);
  return $html;
}

1;
