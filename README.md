# Hashtopolis Server , CUDA Hashcat (beta) with vast.ai


This container is useful for quickly! deploying lots of agents from vast.ai onto your hashtopolis server with single clicks for an ondemand hash cracking session.

### Prerequisities


In order to fully utilize this container you'll need the following

* [hashtopolis](https://github.com/s3inlc/hashtopolis/)
Development branch `git clone -b current-dev --single-branch https://github.com/s3inlc/hashtopolis.git`
* [hashtopolis-agent](https://github.com/s3inlc/hashtopolis-agent-python/) Development branch `git clone -b current-dev --single-branch https://github.com/s3inlc/hashtopolis-agent-python.git` requires building but we have a script for that.
* [vast.ai account](https://vast.ai/)
* [hashcat beta](https://hashcat.net/beta/)

### Usage and Information


This is a CUDA Install, not OpenCL. Kernel load time with CUDA is much quicker than OpenCL

The current hashcat release [v5.1.0	2018.12.02] doesn't support CUDA yet.
In this case you'll require the hashcat (beta) build as an additional cracker binary for hashtopolis. (Prerequisities)

This is a One-Click set up with vast.ai, Just click "Rent" button and your client will auto register with your hashtopolis server and will instantly start working on any available tasks you have waiting.

This container takes the pain out of manually checking boxes and adding in additional parameters for each agent if you want to register alot of agents at one time.

### Hashtopolis Modifications

Each time you register an agent you need to manually update the `Agent Trust Status` and you'll receive HC error `clGetPlatformIDs(): CL_PLATFORM_NOT_FOUND_KHR` due to OpenCL requirements, but we can fix this within hashtopolis developement branch *new_feature*

Hashcat itself will ignore this error and continue with CUDA platform but in hashtopolis's case it will take the error as fatal and halt because by default the agent is set to be deactivated on any errors returned by HC.

We want `whitelist` this error in hashtopolis's server settings, so enter `clGetPlatformIDs(): CL_PLATFORM_NOT_FOUND_KHR` in Server Settings page `config.php` where it says `Ignore error messages from crackers which contain given strings (multiple values separated by comma)`

Cron this script locally to periodically update the your hashtopolis database every 1 minute or so to set new agents as trusted.
```
echo mysql -D your_hashtopolis_db -e \"UPDATE Agent SET isTrusted = '1'\" > set_trust.sh && chmod +x set_trust.sh
```
crontab -e

`* * * * * /root/set_trust.sh >/dev/null 2>&1`

#### config.json

You also need to have reusable voucher codes.
See `https://{your_domain}/config.php?view=5` and checkbox to allow vouchers to be use multiple times.

#### vast.ai

Edit `Image & Config` and use `milz0/hashtopolis-hashcat-vast` as your custom image

your onstart-script should be written out as so in vast.ai.
```
cd htpclient
python3 hashtopolis.zip --url {server} --voucher {voucher_id}
```

#### Misc

For additional parameters like -w4 and -O (optimized kernels), set these globally per task in the command box #HL#
