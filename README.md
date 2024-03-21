# Docker Boilerplate

## Setup the project

### Create a new project
1. Replace the value of `COMPOSE_PROJECT_NAME` inside the `Makefile` with your project name
2. Run `make setup`
3. Open administration and complete configuration
4. Set the variables for deployment inside your github repo <br/>
=> Required variables can be found inside the `.github/workflows/deploy.yml` file

### Setup a freshly cloned project
1. Run `make up`
2. Run `make mysql-restore`
3. Run `make composer install`

## Docker setup

### Linux
https://docs.docker.com/engine/install/ubuntu/ <br/>
https://docs.docker.com/compose/install/ <br/>
<br/>
Open `/etc/hosts`<br/>
<strong>Enter the following lines</strong>:<br/>
`127.0.0.1 shopware.docker`<br/>
`127.0.0.1 mail.docker`

### MacOS
https://runnable.com/docker/install-docker-on-macos <br/><br/>
Open `/etc/hosts`<br/>
<strong>Enter the following lines</strong>:<br/>
`127.0.0.1 shopware.docker`<br/>
`127.0.0.1 mail.docker`

### Windows
https://docs.docker.com/desktop/windows/install/ <br/>
https://docs.docker.com/compose/install/ 
<br/><br/>
Open `C:\Windows\system32\drivers\etc\hosts`<br/>
<strong>Enter the following lines</strong>:<br/>
`127.0.0.1 shopware.docker`<br/>
`127.0.0.1 mail.docker`

## Linting

### PHPMD (PHP Mess Detection)
https://phpmd.org/ <br/>
lint: `make lint-phpmd`

### ECS
https://github.com/symplify/easy-coding-standard <br/>
lint: `make lint-ecs` <br/>
fix: `make fix-ecs`

### PHPSTAN (PHP Static Analysis)
https://phpstan.org/user-guide/getting-started <br/>
lint: `make lint-stan`


### Git Commit Messages
https://www.npmjs.com/package/git-commit-msg-linter <br/>
The linter is automatically executed in the pre commit hook.

## Testing
### Playwright
Coming Soon

## Deployment
The deployment is executed inside a github action. To configure the deployment process you can adjust the `.github/workflows/deploy.yml` <br/>
The process is currently set up for two different scenarios, deployment to a dev server and a production server. <br/>
If you only need one of those scenarios, you can simply remove the other one from the workflow. Feel free to edit or rename the deployment variables.
The variables can be set inside the repositories' settings. Go to `You repository > Settings > Security > Actions` to add your config variables.

### Variables
```
ACCESS_TOKEN => Either your or some other token, which has access to the packages/repositories inside our Github organization
SSH_HOST_DEV => The server name of the dev server
SSH_USER_DEV => The SSH username of the dev server
PRIVATE_KEY => A private SSH key. The relating public key needs to be authorized on the server
SSH_HOST_MAIN => The production server name
SSH_USER_MAIN => Username of the SSH user for the production server
```

## Todos in this project
- Set static IP for mailhog container
- Finalize ECS configuration
- Complete documentation
- Complete github actions and fix codeception action