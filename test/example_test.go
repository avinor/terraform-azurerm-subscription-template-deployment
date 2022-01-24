package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExample(t *testing.T) {
	tfOptions := &terraform.Options{
		TerraformDir: "../examples/simple",
	}

	terraform.Init(t, tfOptions)
	_, err := terraform.RunTerraformCommandE(t, tfOptions, terraform.FormatArgs(tfOptions, "plan")...)
	if err != nil {
		t.Error(err)
	}
}
