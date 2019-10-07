#!/bin/sh

type antibody > /dev/null || curl -sfL git.io/antibody | sh -s - -b $HOME/bin