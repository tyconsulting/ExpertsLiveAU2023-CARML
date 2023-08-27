# Experts Live Australia 2023 CARML Demo

## Instruction

```powershell
new-azdeployment -Location 'Australia East' -Name 'carml' -TemplateFile ./patterns/storage_account/main.bicep -TemplateParameterFile ./patterns/storage_account/main.parameters.json -Verbose

``````