
`R.I.S.K.S` (**R**elatively **I**nsecure **S**ystem for **K**eys and **S**ecrets) is a tool suite for creating, using and managing
different online identities, centered around cryptographic autentication (GPG), communication (SSH) and password
secrets (pass) and QubesOS, with an emphasis on seggregating and isolating these identities and their data.

The original idea and associated script can be found in the [risks-scripts](https://github.com/19hundreds/risks-scripts) repository, along with the associated [tutorials](https://19hundreds.github.io/risks-workflow).

# AppVM

This repository provides a CLI (`risq`) to be used in a **client AppVM**. This script depends on the vault `risks` CLI 
(provided [here](https://github.com/wizardofhoms/risks)), for working correctly, since it also relies on identities that are used and managed in a vault VM.

Functionality includes:
- A wrapper around the `qvm-pass` program (dependency) to query password-store items from the vault.
- Completions for the CLI and the pass wrapper.
- A single CLI in which the functionality is bundled

# Documentation

* [Software used](https://github.com/wizardofhoms/risk/wiki/Software-Used)
* [Installation](https://github.com/wizardofhoms/risk/wiki/Installation)
* [Usage tutorial](https://github.com/wizardofhoms/risk/wiki/Usage-Tutorial)
* [Additional workflows](/https://github.com/wizardofhoms/risk/wiki/Additional-Workflows)
* [Command-line API](/https://github.com/wizardofhoms/risk/wiki/Command-Line-API)
* [Development](/https://github.com/wizardofhoms/risk/wiki/Development)
