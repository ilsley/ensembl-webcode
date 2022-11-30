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
  $html .= qq(<h3>Image Width: $image_width</h3>);
  $html .= qq(<h3>Region length: $region_length</h3>);
  $html .= qq(<h3>Species: $species</h3>);
  $html .= qq(<p>$display_name</p>
            <p>$assembly</p>
            <p>$assembly_version</p>
            <p>$assembly_accession</p>
            <p>$seq_region_name</p>
            <p>$seq_region_start</p>
            <p>$seq_region_end</p>
            <p>$seq_region_strand</p>
            <p>$seq_region_type</p>
        );
  $html .= qq(<div id = "locdata">Empty</div>);
  # $html .= qq(<script>
  #           var app = document.getElementById("app");
  #           app.innerHTML="Changed: $seq_region_start - $seq_region_end"
  #         </script>);
  # $html .= '<div id="app">Empty</div>';
  # $html .= qq(<script type="module">
  #         import init, { epigenome_table, add } from 'http://localhost:3000/assets/pkg/wasm.js';
  #         async function run() {
  #           await init("http://localhost:3000/assets/pkg/wasm_bg.wasm");
  #           const epi_data = [{"name":"Epigenome test: 1","sex":"Male","n":1},{"name":"Epigenome test: 2","sex":"Female","n":2},{"name":"Epigenome test: 3","sex":"Male","n":3},{"name":"Epigenome test: 4","sex":"Female","n":4},{"name":"Epigenome test: 5","sex":"Male","n":5},{"name":"Epigenome test: 6","sex":"Female","n":6},{"name":"Epigenome test: 7","sex":"Male","n":7},{"name":"Epigenome test: 8","sex":"Female","n":8},{"name":"Epigenome test: 9","sex":"Male","n":9},{"name":"Epigenome test: 10","sex":"Female","n":10},{"name":"Epigenome test: 11","sex":"Male","n":11},{"name":"Epigenome test: 12","sex":"Female","n":12},{"name":"Epigenome test: 13","sex":"Male","n":13},{"name":"Epigenome test: 14","sex":"Female","n":14},{"name":"Epigenome test: 15","sex":"Male","n":15},{"name":"Epigenome test: 16","sex":"Female","n":16},{"name":"Epigenome test: 17","sex":"Male","n":17},{"name":"Epigenome test: 18","sex":"Female","n":18},{"name":"Epigenome test: 19","sex":"Male","n":19},{"name":"Epigenome test: 20","sex":"Female","n":20},{"name":"Epigenome test: 21","sex":"Male","n":21},{"name":"Epigenome test: 22","sex":"Female","n":22},{"name":"Epigenome test: 23","sex":"Male","n":23},{"name":"Epigenome test: 24","sex":"Female","n":24},{"name":"Epigenome test: 25","sex":"Male","n":25},{"name":"Epigenome test: 26","sex":"Female","n":26},{"name":"Epigenome test: 27","sex":"Male","n":27},{"name":"Epigenome test: 28","sex":"Female","n":28},{"name":"Epigenome test: 29","sex":"Male","n":29},{"name":"Epigenome test: 30","sex":"Female","n":30},{"name":"Epigenome test: 31","sex":"Male","n":31},{"name":"Epigenome test: 32","sex":"Female","n":32},{"name":"Epigenome test: 33","sex":"Male","n":33},{"name":"Epigenome test: 34","sex":"Female","n":34},{"name":"Epigenome test: 35","sex":"Male","n":35},{"name":"Epigenome test: 36","sex":"Female","n":36},{"name":"Epigenome test: 37","sex":"Male","n":37},{"name":"Epigenome test: 38","sex":"Female","n":38},{"name":"Epigenome test: 39","sex":"Male","n":39},{"name":"Epigenome test: 40","sex":"Female","n":40},{"name":"Epigenome test: 41","sex":"Male","n":41},{"name":"Epigenome test: 42","sex":"Female","n":42},{"name":"Epigenome test: 43","sex":"Male","n":43},{"name":"Epigenome test: 44","sex":"Female","n":44},{"name":"Epigenome test: 45","sex":"Male","n":45},{"name":"Epigenome test: 46","sex":"Female","n":46},{"name":"Epigenome test: 47","sex":"Male","n":47},{"name":"Epigenome test: 48","sex":"Female","n":48},{"name":"Epigenome test: 49","sex":"Male","n":49},{"name":"Epigenome test: 50","sex":"Female","n":50},{"name":"Epigenome test: 51","sex":"Male","n":51},{"name":"Epigenome test: 52","sex":"Female","n":52},{"name":"Epigenome test: 53","sex":"Male","n":53},{"name":"Epigenome test: 54","sex":"Female","n":54},{"name":"Epigenome test: 55","sex":"Male","n":55},{"name":"Epigenome test: 56","sex":"Female","n":56},{"name":"Epigenome test: 57","sex":"Male","n":57},{"name":"Epigenome test: 58","sex":"Female","n":58},{"name":"Epigenome test: 59","sex":"Male","n":59},{"name":"Epigenome test: 60","sex":"Female","n":60},{"name":"Epigenome test: 61","sex":"Male","n":61},{"name":"Epigenome test: 62","sex":"Female","n":62},{"name":"Epigenome test: 63","sex":"Male","n":63},{"name":"Epigenome test: 64","sex":"Female","n":64},{"name":"Epigenome test: 65","sex":"Male","n":65},{"name":"Epigenome test: 66","sex":"Female","n":66},{"name":"Epigenome test: 67","sex":"Male","n":67},{"name":"Epigenome test: 68","sex":"Female","n":68},{"name":"Epigenome test: 69","sex":"Male","n":69},{"name":"Epigenome test: 70","sex":"Female","n":70},{"name":"Epigenome test: 71","sex":"Male","n":71},{"name":"Epigenome test: 72","sex":"Female","n":72},{"name":"Epigenome test: 73","sex":"Male","n":73},{"name":"Epigenome test: 74","sex":"Female","n":74},{"name":"Epigenome test: 75","sex":"Male","n":75},{"name":"Epigenome test: 76","sex":"Female","n":76},{"name":"Epigenome test: 77","sex":"Male","n":77},{"name":"Epigenome test: 78","sex":"Female","n":78},{"name":"Epigenome test: 79","sex":"Male","n":79},{"name":"Epigenome test: 80","sex":"Female","n":80},{"name":"Epigenome test: 81","sex":"Male","n":81},{"name":"Epigenome test: 82","sex":"Female","n":82},{"name":"Epigenome test: 83","sex":"Male","n":83},{"name":"Epigenome test: 84","sex":"Female","n":84},{"name":"Epigenome test: 85","sex":"Male","n":85},{"name":"Epigenome test: 86","sex":"Female","n":86},{"name":"Epigenome test: 87","sex":"Male","n":87},{"name":"Epigenome test: 88","sex":"Female","n":88},{"name":"Epigenome test: 89","sex":"Male","n":89},{"name":"Epigenome test: 90","sex":"Female","n":90},{"name":"Epigenome test: 91","sex":"Male","n":91},{"name":"Epigenome test: 92","sex":"Female","n":92},{"name":"Epigenome test: 93","sex":"Male","n":93},{"name":"Epigenome test: 94","sex":"Female","n":94},{"name":"Epigenome test: 95","sex":"Male","n":95},{"name":"Epigenome test: 96","sex":"Female","n":96},{"name":"Epigenome test: 97","sex":"Male","n":97},{"name":"Epigenome test: 98","sex":"Female","n":98},{"name":"Epigenome test: 99","sex":"Male","n":99},{"name":"Epigenome test: 100","sex":"Female","n":100},{"name":"Epigenome test: 101","sex":"Male","n":101},{"name":"Epigenome test: 102","sex":"Female","n":102},{"name":"Epigenome test: 103","sex":"Male","n":103},{"name":"Epigenome test: 104","sex":"Female","n":104},{"name":"Epigenome test: 105","sex":"Male","n":105},{"name":"Epigenome test: 106","sex":"Female","n":106},{"name":"Epigenome test: 107","sex":"Male","n":107},{"name":"Epigenome test: 108","sex":"Female","n":108},{"name":"Epigenome test: 109","sex":"Male","n":109},{"name":"Epigenome test: 110","sex":"Female","n":110},{"name":"Epigenome test: 111","sex":"Male","n":111},{"name":"Epigenome test: 112","sex":"Female","n":112},{"name":"Epigenome test: 113","sex":"Male","n":113},{"name":"Epigenome test: 114","sex":"Female","n":114},{"name":"Epigenome test: 115","sex":"Male","n":115},{"name":"Epigenome test: 116","sex":"Female","n":116},{"name":"Epigenome test: 117","sex":"Male","n":117},{"name":"Epigenome test: 118","sex":"Female","n":118},{"name":"Epigenome test: 119","sex":"Male","n":119},{"name":"Epigenome test: 120","sex":"Female","n":120},{"name":"Epigenome test: 121","sex":"Male","n":121},{"name":"Epigenome test: 122","sex":"Female","n":122},{"name":"Epigenome test: 123","sex":"Male","n":123},{"name":"Epigenome test: 124","sex":"Female","n":124},{"name":"Epigenome test: 125","sex":"Male","n":125},{"name":"Epigenome test: 126","sex":"Female","n":126},{"name":"Epigenome test: 127","sex":"Male","n":127},{"name":"Epigenome test: 128","sex":"Female","n":128},{"name":"Epigenome test: 129","sex":"Male","n":129},{"name":"Epigenome test: 130","sex":"Female","n":130},{"name":"Epigenome test: 131","sex":"Male","n":131},{"name":"Epigenome test: 132","sex":"Female","n":132},{"name":"Epigenome test: 133","sex":"Male","n":133},{"name":"Epigenome test: 134","sex":"Female","n":134},{"name":"Epigenome test: 135","sex":"Male","n":135},{"name":"Epigenome test: 136","sex":"Female","n":136},{"name":"Epigenome test: 137","sex":"Male","n":137},{"name":"Epigenome test: 138","sex":"Female","n":138},{"name":"Epigenome test: 139","sex":"Male","n":139},{"name":"Epigenome test: 140","sex":"Female","n":140},{"name":"Epigenome test: 141","sex":"Male","n":141},{"name":"Epigenome test: 142","sex":"Female","n":142},{"name":"Epigenome test: 143","sex":"Male","n":143},{"name":"Epigenome test: 144","sex":"Female","n":144},{"name":"Epigenome test: 145","sex":"Male","n":145},{"name":"Epigenome test: 146","sex":"Female","n":146},{"name":"Epigenome test: 147","sex":"Male","n":147},{"name":"Epigenome test: 148","sex":"Female","n":148},{"name":"Epigenome test: 149","sex":"Male","n":149},{"name":"Epigenome test: 150","sex":"Female","n":150},{"name":"Epigenome test: 151","sex":"Male","n":151},{"name":"Epigenome test: 152","sex":"Female","n":152},{"name":"Epigenome test: 153","sex":"Male","n":153},{"name":"Epigenome test: 154","sex":"Female","n":154},{"name":"Epigenome test: 155","sex":"Male","n":155},{"name":"Epigenome test: 156","sex":"Female","n":156},{"name":"Epigenome test: 157","sex":"Male","n":157},{"name":"Epigenome test: 158","sex":"Female","n":158},{"name":"Epigenome test: 159","sex":"Male","n":159},{"name":"Epigenome test: 160","sex":"Female","n":160},{"name":"Epigenome test: 161","sex":"Male","n":161},{"name":"Epigenome test: 162","sex":"Female","n":162},{"name":"Epigenome test: 163","sex":"Male","n":163},{"name":"Epigenome test: 164","sex":"Female","n":164},{"name":"Epigenome test: 165","sex":"Male","n":165},{"name":"Epigenome test: 166","sex":"Female","n":166},{"name":"Epigenome test: 167","sex":"Male","n":167},{"name":"Epigenome test: 168","sex":"Female","n":168},{"name":"Epigenome test: 169","sex":"Male","n":169},{"name":"Epigenome test: 170","sex":"Female","n":170},{"name":"Epigenome test: 171","sex":"Male","n":171},{"name":"Epigenome test: 172","sex":"Female","n":172},{"name":"Epigenome test: 173","sex":"Male","n":173},{"name":"Epigenome test: 174","sex":"Female","n":174},{"name":"Epigenome test: 175","sex":"Male","n":175},{"name":"Epigenome test: 176","sex":"Female","n":176},{"name":"Epigenome test: 177","sex":"Male","n":177},{"name":"Epigenome test: 178","sex":"Female","n":178},{"name":"Epigenome test: 179","sex":"Male","n":179},{"name":"Epigenome test: 180","sex":"Female","n":180},{"name":"Epigenome test: 181","sex":"Male","n":181},{"name":"Epigenome test: 182","sex":"Female","n":182},{"name":"Epigenome test: 183","sex":"Male","n":183},{"name":"Epigenome test: 184","sex":"Female","n":184},{"name":"Epigenome test: 185","sex":"Male","n":185},{"name":"Epigenome test: 186","sex":"Female","n":186},{"name":"Epigenome test: 187","sex":"Male","n":187},{"name":"Epigenome test: 188","sex":"Female","n":188},{"name":"Epigenome test: 189","sex":"Male","n":189}];
  #           epigenome_table(epi_data);
  #       }

  #       run();
  #      </script>);
  return $html;
}

1;
