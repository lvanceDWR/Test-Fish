# This script executes an EMLassemblyline workflow.


# Create templates structure
template_directories(path = ".", dir.name = "edi_2021")


# Initialize workspace --------------------------------------------------------

# Update EMLassemblyline and load

remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "edi_2021/metadata_templates"
path_data <- "edi_2021/data_objects"
path_eml <- "edi_2021/eml"

# Create metadata templates ---------------------------------------------------

# Below is a list of boiler plate function calls for creating metadata templates.
# They are meant to be a reminder and save you a little time. Remove the
# functions and arguments you don't need AND ... don't forget to read the docs!
# E.g. ?template_core_metadata

# Create core templates (required for all data packages)

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".txt",
  write.file = TRUE)

# Create table attributes template (required when data tables are present)

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("effort.csv", "event.csv", "fish_unique.csv", "genetics_salmon.csv", "genetics_smelt.csv", "historical_monthly_trap_effort.csv", "integrated_wq_totalcatch.csv", "station.csv", "taxonomy.csv", "total_catch.csv"))

# Create categorical variables template (required when attributes templates
# contains variables with a "categorical" class)

EMLassemblyline::template_categorical_variables(
  path = path_templates,
  data.path = path_data)

# view_unit_dictionary()

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

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml,
  dataset.title = "Interagency Ecological Program: Fish catch and water quality data from the Sacramento River floodplain and tidal slough, collected by the Yolo Bypass Fish Monitoring Program, 1998-2021.",
  temporal.coverage = c("1998-01-26", "2021-12-30"),
  geographic.description = "Yolo Bypass tidal slough and seasonal floodplain in Sacramento, California, USA",
  maintenance.description = "Collection is ongoing; data updates expected approximately annually",
  data.table = c("effort.csv", "event.csv", "fish_unique.csv", "FKTR_hours_fished_1999-2018.csv", "genetics_salmon.csv", "genetics_smelt.csv", "integrated_wq_totalcatch.csv", "RSTR_hours_fished_1999-2018.csv", "station.csv", "taxonomy.csv", "total_catch.csv"),
  data.table.name = c("Trap Effort", "Water Quality and Environmental Data", "Individual Fish ", "Monthly Fyke Effort, Historical", "Salmon Genetics", "Smelt Genetics", "Integrated Water Quality and Fish Catch", "Monthly Screw Trap Effort, Historical", "Stations", "Taxonomy", "Total Fish Catch"),
  data.table.description = c("Fyke and screw trap effort in hours, starting 2010", "Water quality and environmental data, event level data", "Individual fish lengths and associated data", "Fyke trap effort in monthly hours, use for data prior to 2010", "Salmon genetics data", "Smelt genetics data", "Water quality and environmental data and total fish catch", "Screw trap effort in monthly hours, use for data prior to 2010", "station information", "taxonomic information", "total fish catch"),
  data.table.quote.character = c('"','"', '"'), # If you have columns that have commas in the text, you will need to use "quote = TRUE" when you write your R file (write.csv), and then use this to tell make_eml what is going around your character cells. c(apostrophe, quote, apostrophe, comma, etc...)
  other.entity = c("Metadata_Fish_Publication_v1.0.pdf", "add more"),
  other.entity.name = c("Metadata for YBFMP Fish Data"),
  other.entity.description = c("Metadata for YBFMP Fish Data"),
  user.id = c("csmith", "aquaticecology"),
  user.domain = "EDI",
  package.id = "edi.233.3")
