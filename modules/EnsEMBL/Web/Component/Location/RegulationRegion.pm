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

package EnsEMBL::Web::Component::Location::RegulationRegion;

use strict;
use warnings;

# no warnings "uninitialized";

# use EnsEMBL::Draw::Utils::ColourMap;
# use EnsEMBL::Web::Utils::FormatText qw(helptip);

use parent qw(EnsEMBL::Web::Component::Location);


sub _init {
  my $self = shift;
  $self->cacheable(0);
  $self->ajaxable(0);
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

  $html = qq(<h2>Regulation Region</h2>);
  $html .= qq(<h3>Ensembl Release $release_id</h3>);
  $html .= qq(<h3>Species: $species</h3>);
  $html .= qq(<p>$display_name</p>
            <p>Assembly: $assembly</p>
            <p>Assembly version: $assembly_version</p>
            <p>Assembly accession: $assembly_accession</p>
        );
  $html .= qq(<div id = "locdata">Empty</div>);
  $html .= '<div id="app">Loading...</div>';
  $html .= qq(<script type="module">
          import init, { epigenome_table, add } from 'http://localhost:3000/assets/pkg/wasm.js';
          async function run() {
            await init("http://localhost:3000/assets/pkg/wasm_bg.wasm");
            const epi_data = [{"name":"Epigenome test: 1","sex":"Male","n":1},{"name":"Epigenome test: 2","sex":"Female","n":2},{"name":"Epigenome test: 3","sex":"Male","n":3},
                {"name":"Epigenome test: 4","sex":"Female","n":4},{"name":"Epigenome test: 5","sex":"Male","n":5},{"name":"Epigenome test: 6","sex":"Female","n":6},
                {"name":"Epigenome test: 7","sex":"Male","n":7},{"name":"Epigenome test: 8","sex":"Female","n":8},{"name":"Epigenome test: 9","sex":"Male","n":9},
                {"name":"Epigenome test: 10","sex":"Female","n":10},{"name":"Epigenome test: 11","sex":"Male","n":11},{"name":"Epigenome test: 12","sex":"Female","n":12},
                {"name":"Epigenome test: 13","sex":"Male","n":13},{"name":"Epigenome test: 14","sex":"Female","n":14},{"name":"Epigenome test: 15","sex":"Male","n":15},
                {"name":"Epigenome test: 16","sex":"Female","n":16},{"name":"Epigenome test: 17","sex":"Male","n":17},{"name":"Epigenome test: 18","sex":"Female","n":18},
                {"name":"Epigenome test: 19","sex":"Male","n":19},{"name":"Epigenome test: 20","sex":"Female","n":20},{"name":"Epigenome test: 21","sex":"Male","n":21},
                {"name":"Epigenome test: 22","sex":"Female","n":22},{"name":"Epigenome test: 23","sex":"Male","n":23},{"name":"Epigenome test: 24","sex":"Female","n":24},
                {"name":"Epigenome test: 25","sex":"Male","n":25},{"name":"Epigenome test: 26","sex":"Female","n":26},{"name":"Epigenome test: 27","sex":"Male","n":27},
                {"name":"Epigenome test: 28","sex":"Female","n":28},{"name":"Epigenome test: 29","sex":"Male","n":29},{"name":"Epigenome test: 30","sex":"Female","n":30}];
            epigenome_table(epi_data);
        }

        run();
       </script>);
  return $html;
}

1;
