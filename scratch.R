temp <- accounts |>

  # I DON'T YET KNOW WHY I HAVE TO ADJUST Cora Howe -- her partner Robert is listed as primary in the data
  mutate(
    contact_type = case_when(
      household_id == "54" & account_id == "34713" ~ "Primary Household Contact", # Cora May Howe
      household_id == "54" & account_id == "34712" ~ "Household Contact", # Robert Howe, deceased and DNC
      .default = contact_type
    )
  ) |>
  # filter(account_type=="Individual", group=="account", id=="38532")
  filter(account_type == "Individual") |>
  filter(
    group == "account" |
      (group == "household" &
        str_detect(contact_type, "Primary Household Contact"))
  ) |>
  # captures PHC in combination with anything else CAUTION: keeps company contacts
  select(
    id,
    name,
    group,
    primary_contact = full_name,
    contact_type,
    deceased,
    do_not_contact
  )
