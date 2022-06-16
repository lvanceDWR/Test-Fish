# This script executes an EMLassemblyline workflow. Most of it comes from their template.

# Update EMLassemblyline and load
###################################################
# Run this part (lines 6, 7, 10) in your console before doing anything else for edi because template_directories() will create the folder structure (including the directory you input in dir.name) you need for EDI and this run_EMLassemblyline script that contains the rest of the template code.
#remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

# Run this to create template directory structure. Pick the name of your folder where all EDI-relevant info will go
template_directories(path = ".", dir.name = "edi_2021")
#############################################################

# Initialize workspace --------------------------------------------------------

# Define paths for your metadata templates, data, and EML
dir <- "edi_2021"
path_templates <- paste0(dir, "/metadata_templates")
path_data <- paste0(dir, "/data_objects")
path_eml <- paste0(dir, "/eml")

# Create metadata templates ---------------------------------------------------

# Below is a list of boiler plate function calls for creating metadata templates.
# They are meant to be a reminder and save you a little time. Remove the
# functions and arguments you don't need AND ... don't forget to read the docs!
# E.g. ?template_core_metadata

# Create core templates (required for all data packages)
# markdown cheatsheet: https://www.markdownguide.org/cheat-sheet/

### For all the markdown text containing underscores, you need to put a backslash in front of it so that markdown doesn't start italicizing everything. This is applicable to all the filenames. (DWR-6-SOP-018\_v1.1\_RotaryScrewTrapSampling)
EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".md",
  write.file = TRUE)

# Create table attributes template (required when data tables are present)
# you will input the data tables included in your dataset

### Run the line below with the names of your data tables, then fill in the templates.
### I fill this out in an Excel workbook, with one template per sheet. This helps for inputting all this information into the word versions of the tables (for the user-friendly metadata). Then I copy everything into the .txt files.
EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("effort.csv", "event.csv", "fish_unique.csv", "genetics_salmon.csv", "genetics_smelt.csv",  "integrated_wq_totalcatch.csv", "station.csv", "taxonomy.csv", "total_catch.csv", "monthly_trap_effort.csv"))


# Create categorical variables template (required when attributes templates
# contains variables with a "categorical" class)

### Run this once the above metadata has been filled out.
EMLassemblyline::template_categorical_variables(
  path = path_templates,
  data.path = path_data)

# Look at standard units in the package. Need to create custom units if they aren't in here.
# Run view_unit_dictionary() to look at the units EML has standard. See custom units example for filling out custom units.

# Create geographic coverage (required when more than one geographic location
# is to be reported in the metadata).

EMLassemblyline::template_geographic_coverage(
  path = path_templates,
  data.path = path_data,
  data.table = "station.csv",
  lat.col = "Latitude",
  lon.col = "Longitude",
  site.col = "StationName")

# Create taxonomic coverage template (Not-required. Use this to report
# taxonomic entities in the metadata)

remotes::install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)

taxonomyCleanr::view_taxa_authorities()

EMLassemblyline::template_taxonomic_coverage(
  path = path_templates,
  data.path = path_data,
  taxa.table = "taxonomy.csv",
  taxa.col = "Taxa",
  taxa.name.type = "scientific",
  taxa.authority = 3,
  empty = FALSE,
  write.file = TRUE)

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create
# the EML.

### The data.table includes the actual data you are including.
### The other.entity includes the pdf version of the metadata, table structure diagram, code files, and any other metadata or files you want to include. I include links to the SOPs cited in the metadata on the GitHub.
### We publish under aquaticecology, but if you wanted to include a personal username (first you need to ask EDI for one), you could add that. We probably don't need to include csmith next time, we needed it this time because aquaticecology was not included in the previous version.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml,
  dataset.title = "Interagency Ecological Program: Fish catch and water quality data from the Sacramento River floodplain and tidal slough, collected by the Yolo Bypass Fish Monitoring Program, 1998-2021.",
  temporal.coverage = c("1998-01-26", "2021-12-30"),
  geographic.description = "Yolo Bypass tidal slough and seasonal floodplain in Sacramento, California, USA",
  maintenance.description = "Collection is ongoing; data updates expected approximately annually",
  data.table = c("effort.csv", "event.csv", "fish_unique.csv",  "genetics_salmon.csv", "genetics_smelt.csv", "integrated_wq_totalcatch.csv",  "station.csv", "taxonomy.csv", "total_catch.csv", "monthly_trap_effort.csv"),
  data.table.name = c("Sampling Effort", "Water Quality and Environmental Data", "Individual Fish Length and Associated Data",  "Salmon Genetics", "Smelt Genetics", "Integrated Water Quality and Fish Catch",  "Stations", "Fish Taxonomy", "Total Fish Catch", "Historical Monthly Trap Effort"),
  data.table.description = c("Sampling Effort for Beach Seine (SeineVolume) and Traps (Hours), starting 2010", "Water quality and environmental data, event level data", "Individual fish lengths and associated data", "Salmon genetics data", "Smelt genetics data", "Water quality and environmental data and total fish catch",  "Station information", "Fish taxonomic information", "total fish catch", "Trap effort in monthly hours, use for data prior to 2010"),
  data.table.quote.character = c('', '"','"','"', '"','"','"', '', '', '"'), # If you have columns that have commas in the text, you will need to use "quote = TRUE" when you write your R file (write.csv), and then use this to tell make_eml what is going around your character cells. c(apostrophe, quote, apostrophe, comma, etc...)
  other.entity = c("Metadata_Fish_Publication_v1.0.pdf", "YBFMP_Fish_Data_Organization.pdf", "clean_fish_tables.Rmd", "integrate_fish_data.Rmd", "qc_calculate_effort_traps.Rmd"),
  other.entity.name = c("Metadata for YBFMP Fish Data", "Fish Data Tables Organization", "Code for cleaning fish tables", "Code for integrating fish tables", "Code for calculating trap effort"),
  other.entity.description = c("Metadata for YBFMP Fish Data", "Fish Data Tables Organization", "Code for cleaning fish tables", "Code for integrating fish tables in different ways", "Code for calculating trap effort"),
  user.id = c("csmith", "aquaticecology"),
  user.domain = "EDI",
  package.id = "edi.233.3") # update the package ID by 0.1 every time you create a new version
