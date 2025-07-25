# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Quarto book project for the Hubbard Hall Fundraising Committee, analyzing donor data to identify top contributors and provide insights for fundraising efforts. The project processes data from the Neon CRM system and external Excel files to create comprehensive donor profiles.

## Common Development Commands

### Quarto Operations

- **Render the book**: `quarto render`
- **Preview during development**: `quarto preview`
- **Publish to Netlify**: `quarto publish netlify `This is not yet implemented but will be once I am ready to push the html pages to the web.
- **Publish without rendering**: `quarto publish netlify --no-render`
- **Publish silently**: `quarto publish netlify --no-render --no-browser --no-prompt`

### R Development

* **Load all libraries**: `source("libraries.R")` (run this first in any R session)
* **Open in RStudio**: Open the `hhfrc.Rproj` file. This file only exists to make it easy to edit the project in RStudio. In practice I expect to work in positron rather than RStudio.

## Architecture and Data Flow

### Key Files Structure

- `libraries.R`: Central dependency management - loads all required R packages
- `get_convert_and_save_data.qmd`: Data ingestion and preprocessing pipeline
- `analysis.qmd`: Main analysis generating donor insights and reports
- `_quarto.yml`: Book configuration with chapter order and publishing settings

### Data Pipeline

1. **Raw Data Sources and interim data files** (`data-raw/`):

   - `neon/`: CSV exports from Neon CRM system (accounts, donations, events, registrations)
   - `judy/`: Excel files with donor lists and manual data obtained from Judy.
   - `work/`: Temporary processing files and metadata
2. **Processing** (`get_convert_and_save_data.qmd`):

   - Variable name mapping between Neon fields and standardized names
   - Data cleaning and standardization
   - Saves processed data as RDS files in `data-raw/rds/`
3. **Analysis** (`analysis.qmd`):

   - Loads processed RDS files
   - Generates top donor lists (all-time and 5-year)
   - Creates comprehensive donor profiles with gift categories

### Key Data Objects

- `accounts`: Individual and company account information
- `donations`: Donation records with amounts and dates
- `events`: Event information for registrations
- `registrations`: Event registration data
- `linkages`: Relationships between contacts and accounts
- `contacts`: Contact information and household linkages

### Variable Name Mapping System

The project uses an iterative variable mapping function (`vmap()`) in `get_convert_and_save_data.qmd:49` to standardize Neon CRM field names into consistent R variable names. This mapping is stored in Excel files and RDS format for reuse.

**Key Variable Name Mappings:**
- Neon field names are converted to lowercase with underscores
- Common mappings include:
  - `Full Name` → `full_name`
  - `HH Name` → `hh_name` 
  - `HH Acct Name` → `hh_acct_name`
  - `Do Not Contact` → `do_not_contact`
  - `Full Address` → `full_address`
  - Donation/registration amounts: `reg_all_amount`, `donation_all_amount`

The complete mapping is maintained in `data-raw/rds/variable_lookup.rds` and applied via the `lookup` vector using `rename(any_of(lookup))`.

### Output

- Generated book is published to `_web/` directory
- Can be published to Netlify for web hosting
- Analysis produces donor rankings and detailed profiles for fundraising use
