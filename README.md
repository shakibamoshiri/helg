# helg
Hurricane Electric's Network Looking Glass

Hurricane Electric as root server does provide any kind of API to request with.
It does have **telnet** over [route-server.he.net
](telnet://route-server.he.net/) but is not so friendly to work with, thus you
can think of this bash CLI as pseudo-API.

## prerequisites
Before proceeding the bellow commands should already have been installed:

 - `perl`
 - `curl`
 - `echo`
 - `printf`
 - `grep`
 - [pup](https://github.com/ericchiang/pup) HTML parser for `txt` output
 - [jq](https://github.com/stedolan/jq) JSON parser for `json` output

Plus you can check them using below option, and it shows you either [OK] or [Error].
```bash
./cli.sh --check cmd
check prerequisites:
curl .......................... [ OK ]
perl .......................... [ OK ]
pup ........................... [ OK ]
grep .......................... [ OK ]
printf ........................ [ OK ]
echo .......................... [ OK ]
```

## download
**clone** the repository using `git`:
```bash
git clone https://github.com/k-five/helg.git && cd helg
```
### check if you have prerequisites
```bash
./cli.sh --check cmd
```
If all the check were [ OK ], then you can use or install it.

### install it
You can use the `cli.sh` file or you may want to change the name and install it
with a proper name e.g. `helg` and then `mv` it to `/usr/local/bin` so you can run
it everywhere on you machine.
```bash
sudo mv cli.sh /usr/local/usr/helg
# or
sudo cp cli.sh /usr/local/usr/helg
# or just use it
./cli.sh ...
```

## how to use
First run the `--help` to see available options. It has two main options:
 1. `--ip`
 2. `--log`

The `--ip` option can read list of IPs/Mask from a file or from the Terminal as
many as you need. If the argument is a single one, first it checks if it is a
file or not, if it was a file, reads it, otherwise it will assume it is an IP.

the `--log` option has three mode:
 1. `html` for log as html file (enabled by default)
 2. `txt` for log as txt file
 3. `term` for print on Terminal (stdout)
 4. `json` for log as JSON file


## exampells
```bash
# request for 8.8.8.8/24 , read from Terminal
./cli --ip 8.8.8.8/24
# or more then one ip/mask
./cli --ip 8.8.8.8/24 1.1.1.1/24

# request , read from a file
./cli --ip ips-sample

# request, enable txt log
./cli --ip ips-sample --log txt

# request, enable Terminal log
./cli --ip ips-sample --log term

# request, enable Terminal log and txt
./cli --ip ips-sample --log term txt

# note that HTML log is enable by default
```

## automation
It will be useful if we automate requests and later check the log.

### crontab
```bash
# every hour at minute 0
# 12:00
# 13:00
# 14:00
# etc

WD='/add/your/working/directory'
0 */1 * * * cd $WD && ./cli.sh --ip ips-file --log txt

# or if you renamed the "cli.sh" to "helg"
WD='/add/your/working/directory'
0 */1 * * * cd $WD && helg --ip ips-file --log txt
```


## NOTE
Hurricane Electric website : https://lg.he.net/  
Router (as default): Hurricane Electric Fremont 1  
Address of this router: core3.fmt1.he.net  
Commands: BGP Route  

## developers
Contribution and feature request are welcome.
