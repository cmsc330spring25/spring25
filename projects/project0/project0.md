
# Project 0: Setup

Due: Wednesday, September 4, 2024 at 11:59 PM

This project is simply to get your system ready. Although you will "submit" this project on Gradescope, it is not counted towards your final grade.  The good-faith attempt (GFA) rule **does not apply** to this project.


## Table of Contents
- [Project 0: Setup](#project-0-setup)
  - [Table of Contents](#table-of-contents)
  - [Instructions](#instructions)
    - [Install Software](#install-software)
    - [Set Up SSH Authentication](#set-up-ssh-authentication)
    - [Link GitHub to Gradescope](#link-github-to-gradescope)
    - [Checkout on GitHub Classroom](#checkout-on-github-classroom)
    - [Verify Setup](#verify-setup)
    - [Submit to Gradescope](#submit-to-gradescope)
  - [Additional Information](#additional-information)
    - [Languages and Packages](#languages-and-packages)
    - [Visual Studio Code](#visual-studio-code)
      - [Extensions](#extensions)
      - [Windows VSCode Setup](#windows-vscode-setup)
  - [Troubleshooting 'submit'](#troubleshooting-submit)
    - [Incorrect Password](#incorrect-password)
    - [Submission failed. Did you connect GitHub to Gradescope?](#submission-failed-did-you-connect-github-to-gradescope)
    - [HTTP Errors](#http-errors)
    - [Failed Gradescope Compilation](#failed-gradescope-compilation)
  - [OS Specific Instructions](#os-specific-instructions)
    - [Windows](#windows)
    - [MacOS](#macos)
      - [Special MacOS Instructions](#special-macos-instructions)
    - [Linux (NOT WSL)](#linux-not-wsl)

## Instructions
**Make sure to read all steps carefully.**

### Install Software

The following sections will help you install the necessary packages and programs on your operating system. Some steps may take a long time. Please be patient.

The output of each command is important, so please pay careful attention to what each one prints. **Do not ignore error messages**.  We will be available in office hours to help you get set up if you run into problems.  As a general rule, blank output means the command executed successfully.

**Please skip to the section below that corresponds with your operating system.**
Once you finish installation, move on to setting up SSH authentication.
- [Windows](#windows)
- [macOS](#macos)
- [Linux (NOT WSL)](#linux-not-wsl)

Once you have successfully completed the above steps **please make sure to come back here to complete the remaining steps!**

### Set Up SSH Authentication

**If you are on Windows, do the key setup and clone in WSL. NOT in Powershell/CMD**
These instructions work for all operating systems.
1. Open Terminal
2. Paste `ssh-keygen -t ed25519 -C "your_email@example.com"`, substituting your GitHub email address (terpmail and personal both work)
3. When you're prompted to "Enter a file in which to save the key", you can **press Enter to accept the default file location**. Please note that if you created SSH keys previously, ssh-keygen may ask you to rewrite another key. If this is the case, press `ctrl + c` to cancel the generation, you already have a key.
4. At the prompt, type a secure passphrase. I prefer something short - you will be typing this a lot. A weak password is a hell of a lot better than no password.

You have now created a public/private key pair located at `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub`
Next, we will add your public key to your GitHub account

5. Run `cat ~/.ssh/id_ed25519.pub` and copy the public key that is displayed.
6. Go to [https://github.com/settings/keys](https://github.com/settings/keys)
7. Click "Add a new SSH key"
8. Paste in your copied public key, it should look like: `ssh-ed25519 <64 characters of hash> <your email>`
9. Add the key. You can now authenticate this computer to GitHub using SSH. 

Optional: If you do not want to type the password every time you push/pull [Use `ssh-add` to add the key to the SSH agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?#adding-your-ssh-key-to-the-ssh-agent) If you are on windows, use the Linux instructions in WSL. Do not continue to the hardware security key section.


### Link GitHub to Gradescope

**IMPORTANT**
Log into your Gradescope account and go to your account settings. Scroll down to the `Linked Accounts` section. If you do not already
have your GitHub account linked here, click the `Link a GitHub account` button, and log into your GitHub account.

### Checkout on GitHub Classroom

**These steps apply to every project**
1. [Checkout the project to create your repository](https://classroom.github.com/a/ytWup6yv) - you will have to do this for every project. After you checkout the project, click the generated link displayed to bring you to the repository page.

Next, you will need to clone this repository to your local filesystem.

**IMPORTANT INFO FOR WINDOWS USERS:** Clone ALL projects into your WSL filesystem, NOT the Windows filesystem. Your path should NOT start with `/mnt` - you can get to the WSL filesystem using `cd ~`

2. Open Terminal
3. Create a directory for your 330 projects, I recommend `mkdir ~/cmsc330spring24`
4. Clone project 0 into that directory
    - Navigate to your 330 directory `cd ~/cmsc330spring24` 
    - Clone the project into your current directory `git clone git@github.com:cmsc330fall24/p0-YOUR_GITHUB_USERNAME` (you must edit the link with your github username)
    - You can also find this link by clicking the green "Code" button on your project 0 GitHub page and copying the link under "SSH"

The files in the `project0` folder will be used for the [Verify Setup](#verify-setup) section at the bottom.

### Verify Setup

To verify that you have the correct versions installed, run `./public.sh` in the `~/cmsc330spring24/project0/` directory.  You should not get any errors.

This will create a file called `p0.report` that will be processed by the autograder in the next steps.

### Submit to Gradescope

Whenever you want to submit your project to Gradescope, you will need to push your latest code changes to your repo. Follow these steps to do so:

First, make sure all your changes are pushed to GitHub using the `git add`, `git commit`, and `git push` commands. We will teach you basic git usage during the first discussion, but you can refer to [these notes](https://bakalian.cs.umd.edu/assets/notes/git.pdf) for assistance. Additionally, you can refer to a [testing repo](https://github.com/CliffBakalian/git-basics) Cliff made, but it's recommended you make your own.
- If you have an author identity error when committing, run the config commands that are shown, filling in your GitHub account email and your name.

Next, to submit your project, you can run `submit` from your project directory.

The `submit` command will pull your code from GitHub, not your local files. If you do not push your changes to GitHub, they will not be uploaded to Gradescope.

If you encounter errors in this section (potentially mentioned [here](#troubleshooting-submit)), you can manually submit the file to Gradescope for now by uploading the p0.report file to the appropriate assignment, but we recommend to make sure the submit process works for future projects.

Upon opening your submission on Gradescope, the tests will show if there are issues with the vital parts of your installation.

## Additional Information
### Languages and Packages

In this course, we will be programming in OCaml and Rust.  Below is a summary of the packages that need to be installed.  You do not need to use these links, they are just for reference or learning more about the languages and/or packages.  You can skip to the instructions below.

- [Git](https://git-scm.com/)
- [OCaml](http://ocaml.org)
    - [OPAM](https://opam.ocaml.org)
    - [OUnit](https://opam.ocaml.org/packages/ounit)
    - [dune](https://opam.ocaml.org/packages/dune)
    - [utop](https://opam.ocaml.org/packages/utop)
- [Rust](https://www.rust-lang.org)

### Visual Studio Code

There is no required text editor/IDE for this course, however, instructors are familiar with [VS Code](https://code.visualstudio.com/download) so we recommend it.

If you want to open VS Code from a terminal, it needs to be added to your path. Open VS Code, open the command palette, and type in `Shell Command`, select the option to install the `code` command in PATH. Next time you open a shell, you can use `code <folder / file>` to open that folder/file in VS Code.

#### Extensions

Here is a short list of some useful extensions; feel free to explore the marketplace for more.

- Remote development
  - [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh): lets you connect a local VS Code instance to a remote filesystem via SSH
     - [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer): lists available machines to connect to with SSH
  - [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl): for Windows users
- Git
  - [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)
  - [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- OCaml
  - [OCaml Platform](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform): make sure you read the setup instructions to install `ocamllsp`
- Rust
  - [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer): consider also enabling [Clippy support](https://rust-analyzer.github.io/manual.html#clippy) and additional [inlay hints](https://rust-analyzer.github.io/manual.html#inlay-hints)


#### Windows VSCode Setup

It is recommended to use Vscode on Windows because of its integration with WSL. With the WSL extension, you can open a WSL terminal within VSCode.
1. Install the WSL extension in VSCode
2. Click the >< icon labeled `Open a remote window` located in the very bottom left corner of the screen.
3. Select "Connect to WSL" - Now VSCode will be loaded within WSL, it will now be using the Linux filesystem and terminal.
4. Use `` ctrl + ` `` to open a terminal. 
5. Now you can type fun terminal commands like `ls` (or just use it for normal things like cloning repositories, running tests, etc...)

For future projects, you will select `open folder` to open the Linux folder containing the project and edit the files, while using the wsl terminal for compilation, testing, and submitting.

## Troubleshooting 'submit'
### Incorrect Password

Make sure that the email address and password you entered are of the account
where your CMSC 330 course enrollment shows up. (If you log in through "school
credentials" option and don't remember your **Gradescope** password, please
reset it.) Many people have multiple Gradescope accounts, and
we suggest you to merge them before trying to submit.

### Submission failed. Did you connect GitHub to Gradescope?

You didn't connect GitHub to Gradescope. 
Go to [Gradescope account settings](https://www.gradescope.com/account/edit), and "Link a GitHub account"

### HTTP Errors

Remove the `submit` config file by doing
`rm -r ~/.gradescope-submit`. Then, refer to the troubleshooting for incorrect
passwords and try it again.

### Failed Gradescope Compilation

You didn't push your changes to GitHub...

## OS Specific Instructions
### Windows

*This will only work on Windows 10 and newer.  If you are on an older version, you will probably need to set up a Linux VM.*
**All instructions must be executed within WSL, NOT in Powershell**

1. Follow the directions [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to install the Windows Subsystem for Linux
2. Make sure you are on WSL 2 with [this test](https://learn.microsoft.com/en-us/windows/wsl/install#check-which-version-of-wsl-you-are-running)
3. Install the basic dependencies:
    - Run `sudo apt update && sudo apt upgrade` to update your local package listing
    - Run `sudo apt install ocaml-native-compilers camlp4 make m4 curl libssl-dev pkg-config unzip graphviz`
4. Install and initialize the OCaml package manager
    - Run `sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)` (when prompted for the installation location, just hit enter to select the default)
        - Run `opam --version`.  You should be on version 2 (followed by some versions; just make sure the major version is 2).
        - If you encounter any issues, check out [the manual](https://opam.ocaml.org/doc/Install.html)
    - Run `opam init --disable-sandboxing`
      - If it hangs at "Fetching repository information", press Enter. This may take a while. Please be patient
      - When prompted to modify `~/.profile` (or another file), **do not** modify the file, type `N` or `5`, but remember the filename (usually `~/.profile`).
        - If you accidentally accept the change, delete the line that was added `test -r '/home/username/.opam/opam-init/init.sh' && . '/home/username/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true` during the next step.
    - Open `~/.profile` (or the file mentioned above) in any text editor (eg. `nano` `code .` `vim` `emacs`)
      - Add the line `` eval `opam config env` `` to the end of the file (these are backticks, not single quotes)
      - Save and exit the file
    - Run `source ~/.profile` (or the file you just edited)
5. Initialize OCaml
    - We will be using OCaml version 4.14.X.  Run `ocaml -version` to check
      which version is currently installed
    - **If you are already on 4.14.X, you can skip to step #6**, if not, follow the instructions below
      - If you are on another version, run `opam switch create 4.14.0` (This may take a while. Please be patient)
      - Run `echo 'eval $(opam env --switch=4.14.0)' >> ~/.bashrc`
      - **Restart** your shell
      - Ensure you are now on the correct version by running `ocaml -version`
6. Install OCaml packages
    - Run `opam install gradescope_submit ocamlfind ounit utop dune qcheck ocamlformat`
      - If you get the message "opam believes some required external dependencies are missing", select "Run apt-get to install them"
7. Install Rust
    - Go to [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install) and run the installation command provided. Make sure you are running the WSL command provided, *not* downloading Rust for Windows.
      - If prompted, just select the defaults
    - Append `~/.cargo/bin` to the `PATH` environment variable.
      - Run `echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc`
      - **Restart** your shell
    - Optional: install the [Clippy](https://doc.rust-lang.org/clippy/) lint tool with `rustup component add clippy`
8. Jump back to [Set Up SSH Authentication](#set-up-ssh-authentication) to complete the remaining steps for this project.

### MacOS

Check the [Special macOS Instructions](#special-macos-instructions) to check if you need to follow any special steps. **Then**, come back here.

0. Update your operating system (optional but recommended)
1. Install the Homebrew package manager
    - Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` 
2. Install the basic dependencies
    - Run `brew install opam openssl graphviz`
      - if you get an error on running this command then it means that brew is currently not in your PATH. To add brew to your PATH run the command `eval "$(/opt/homebrew/bin/brew shellenv)"`
3. Initialize the OCaml package manager
    - Run `opam init`
    - When prompted to modify `~/.zshrc` or `~/.bash_profile` (or a similar file), **do not** modify the file, type `N` or `5`
    - Run  `eval $(opam env)`
4. Initialize OCaml
    - We will be using OCaml version 4.14.X.  Run `ocaml -version` to check
      which version is currently installed
    - **If you are already on 4.14.X, you can skip to step #5**, if not, follow the instructions below
      - If you are on another version, run `opam switch create 4.14.0` (This may take a while. Please be patient)
      - Ensure that all new shells open using the correct ocaml version. First, do `echo $SHELL`.
        - If `echo $SHELL` gives `/bin/zsh`, run `echo 'eval $(opam env --switch=4.14.0)' >> ~/.zshrc`
        - If `echo $SHELL` gives `/bin/bash`, run `echo 'eval $(opam env --switch=4.14.0)' >> ~/.bashrc`
      - **Restart** your shell
      - Ensure you are now on the correct version by running `ocaml -version`
5. Install OCaml packages
    - Run `opam install gradescope_submit ocamlfind ounit utop dune qcheck ocamlformat`
      - If you get the message "opam believes some required external dependencies are missing", select "Run brew to install them"
      - Run `eval $(opam config env)`
6. Install Rust
    - Go to [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install) and run the installation command provided
    - If prompted, just select the defaults
    - Append `~/.cargo/bin` to the `PATH` environment variable. First, do `echo $SHELL`.
      - If `echo $SHELL` gives `/bin/zsh`, run `echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc`
      - If `echo $SHELL` gives `/bin/bash`, run `echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc`
      - **Restart** your shell
    - Optional: install the [Clippy](https://doc.rust-lang.org/clippy/) lint tool with `rustup component add clippy`
7. Jump back to [Set Up SSH Authentication](#set-up-ssh-authentication) to complete the remaining steps for this project.

#### Special MacOS Instructions

Check to see if you're running an older version of macOS. Either click the Apple button in the menubar in the top-left and click "About This Mac", or else run `sw_vers` from the terminal. You should only need the special section if your macOS version is less than 10.15

If your macOS version is less than 10.15, follow [the directions for macOS](#macos), but with the changes listed below. Otherwise, ignore the following section.

- If you have run the special instructions in previous classes or semesters, undo by uninstalling homebrew:
  - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"`
  - You will probably have leftover files in `/opt/homebrew` or `/usr/local`. We will *try* to help you delete them in OH.
- Afterwards, run `brew install` INDIVIDUALLY on each of ocaml, opam, openssl.
  - so `brew install ocaml`, `brew install opam`, etc.

### Linux (NOT WSL)

These instructions assume you have a Debian-based system (e.g. Ubuntu) using the Bash shell.  If you have a different distribution, you will have to find and download the corresponding packages in your native package manager. Note that the packages there may have slightly different names. Note that commands that modify `.bashrc` will need to be changed to modify your respective `.rc` file.

1. Firstly, install the basic dependencies:
    - Run `sudo apt update` to update your local package listing
    - Run `sudo apt install ocaml-native-compilers camlp4 make m4 curl libssl-dev pkg-config graphviz`
2. Install and initialize the OCaml package manager
    - Run `sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)` (when prompted for the installation location, just hit enter to select the default)
      - Run `opam --version`.  You should be on version 2 (followed by some versions, just make sure the major version is 2).  Check out [the manual](https://opam.ocaml.org/doc/Install.html) if this is not the case, you may have to follow special directions for your particular operating system and version.
      - If you encounter any issues, or are running a different flavor of Linux, check out [the manual](https://opam.ocaml.org/doc/Install.html)
    - Run `opam init`
      - If it hangs at "Fetching repository information" press Enter. (This may take a while. Please be patient)
      - When prompted to modify `~/.profile` (or another file), **do not** modify the file, type `N` or `5`
    - Run `eval $(opam env)`
3. Initialize OCaml
    - We will be using OCaml version 4.14.X. Run `ocaml -version` to check which version is currently installed
    - **If you are already on version 4.14.X, you can skip to step #4**, if not, follow the instructions below
      - If you are on another version, run `opam switch create 4.14.0` (This may take a while. Please be patient)
      - Run `echo 'eval $(opam env --switch=4.14.0)' >> ~/.bashrc`
      - **Restart** your shell
      - Ensure you are now on the correct version by running `ocaml -version`
4. Install OCaml packages
    - Run `opam install gradescope_submit ocamlfind ounit utop dune qcheck ocamlformat`
5. Install Rust
    - Go to [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install) and run the installation command provided
    - If prompted, just select the defaults
    - Append `~/.cargo/bin` to the `PATH` environment variable.
      - Run `echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc`
      - **Restart** your shell
    - Optional: install the [Clippy](https://doc.rust-lang.org/clippy/) lint tool with `rustup component add clippy`
6. Jump back to [Set Up SSH Authentication](#set-up-ssh-authentication) to complete the remaining steps for this project.
