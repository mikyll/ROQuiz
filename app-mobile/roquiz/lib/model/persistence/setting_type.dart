enum SettingType {
  toggleSwitch,
  toggleCheckbox,
  toggleCheckboxAndButton,
  spinner,
  button,
}

// TODO
SettingType inferFromValue(dynamic value) {
  if (value is bool) {
    return SettingType.toggleCheckbox;
  }
  if (value is int) {
    return SettingType.spinner;
  }

  return SettingType.toggleCheckbox;
}
