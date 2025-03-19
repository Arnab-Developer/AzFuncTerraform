# Azure Function Terraform

Create azure function with terraform. After creating the function, we need to deploy the code inside it.

Code deploy steps:

- Create a new function app in visual studio.
- Publish that function app in a folder.
- Zip that folder.
- Run azure cli command to publish in the azure function app.
  ```powershell
  az functionapp deployment source config-zip `
      -g "rg-terraapp1-dev" `
      -n "func-terraapp1-dev" `
      --src "./publish.zip"
  ```
