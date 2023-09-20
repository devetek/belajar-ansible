package utils

import (
	"os"

	"github.com/devetek/belajar-ansible/constants"
)

func RemoveKnownHost() error {
	err := os.Remove(constants.ANSIBLE_USER_KNOWN_HOST)
	if err != nil {
		return err
	}

	return nil
}
