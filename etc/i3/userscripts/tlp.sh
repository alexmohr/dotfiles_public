#!/bin/bash
file=/etc/tlp.conf
tmp_file=/tmp/tlp
tlp_mode_ac=AC
tlp_mode_bat=BAT
opositeMode=$tlp_mode_ac
tlp_mode=$tlp_mode_bat
if [[ `cat /sys/class/power_supply/AC/online` -eq 1 ]]; then
  tlp_mode=$tlp_mode_ac
  opositeMode=$tlp_mode_bat
fi

script_path="/etc/i3/userscripts/"
source "$script_path/util.sh"


function getPowerSettings {
  t=2
  x="Power"
  getPerformanceHints
  y=`echo $current | sed 's/_/ /g'`
  y=`echo "\uf3fd ${y^}"`
  addState $x $y
  power=`echo -e $y`
}

function getPowerDissipation {
  t=1
  x="Power Limit"
  getCurrentPowerDissipation
  y=`echo $current | sed 's/_/ /g'`
  y=`echo "\uf83e ${y^}%"`
  addState $x $y
  dissipation=`echo -e $y`
}

function getFullCharge {
  t=2
  x="Battery"
  y=`echo "\uf5e7 Full Charge"`
  addState $x $y
  fullcharge=`echo -e $y`
}

function getMode {
  t=1
  x="Change to"
  if [ "$opositeMode" = "AC" ]; then
    y="\uf1e6 $opositeMode settings"
  else
    y="\uf5df $opositeMode settings"
  fi

  addState $x $y
  mode=`echo -e $y`
}

function tlpMainMenu {
  options=""
  getPowerSettings
  getPowerDissipation
  getFullCharge
  getMode


  result=`echo -e "$options" | $dmenu "$tlp_mode Power settings"`

  case "$result" in
    "$dissipation")
      powerDissipation
      ;;
    "$power")
      performanceHints
      ;;
    "$fullcharge")
      sudo tlp fullcharge BAT1
      sudo tlp fullcharge BAT0
      exit 0
      ;;
    "$mode")
      opositeMode=$tlp_mode
      if [[ $tlp_mode == $tlp_mode_bat ]]; then
        tlp_mode=$tlp_mode_ac
      else
        tlp_mode=$tlp_mode_bat
      fi
      tlpMainMenu
      ;;
    *)
      exit 1
  esac    
}

function getPerformanceHints { 
  option1=CPU_HWP_ON_$tlp_mode
  getTlpOption $option1
}

function performanceHints {
  option1=CPU_HWP_ON_$tlp_mode
  option2=ENERGY_PERF_POLICY_ON_$tlp_mode
  getPerformanceHints
  current=`echo $current | sed 's/_/ /g'`
  current=`echo "${current^}"`
  result=`echo -e "Balance power\nBalance performance\nPower\nPerformance\n← Back" | $dmenu "Set power options (current $current)"`

  case "$result" in
    "← Back")
      tlpMainMenu
      ;;
    "Balance power")
      setOption $option1 balance_power
      setOption $option2 balance_power
      ;;
    "Balance performance")
      setOption $option1 balance_performance
      setOption $option2 balance_performance
      ;;
    "Power")
      setOption $option1 power
      setOption $option2 power
      ;;
    "Performance")
      setOption $option1 performance
      setOption $option2 performance
      ;;
    *)
      exit 1
  esac
}

function getCurrentPowerDissipation { 
  option=CPU_MAX_PERF_ON_$tlp_mode
  getTlpOption $option
}

function powerDissipation {
  getCurrentPowerDissipation

  result=`echo -e "25%\n50%\n75%\n100% (disable)\n← Back" | $dmenu "Limit cpu dissipation to (current: $current)"`

  case "$result" in
    "← Back")
      tlpMainMenu
      ;;
    "25%")
      enableOption $option
      setOption $option 25
      ;;
    "50%")
      enableOption $option
      setOption $option 50
      ;;
    "75%")
      enableOption $option
      setOption $option 75
      ;;
    "100% (disable)")
      setOption $option 100
      disableOption $option
      ;;
    *)
      exit 1
  esac
}

function enableOption {
  edit "sed -ie "s/^\#$1=.*/$1=.*/" $tmp_file"
  }

function disableOption {
  edit "sed -ie "s/^$1/\#$1/" $tmp_file"
  }

function setOption {
  edit "sed -ie "s/^$1=.*/$1=$2/" $tmp_file"
}

function getTlpOption {
  current=`cat $file | grep $1`
  if [[ $current == \#* ]]; then
    current="disabled"
    else
      current=`echo $current | cut -f 2 -d '='`
  fi
}

function edit {
  cp $file $tmp_file
  $1
  cp $tmp_file $file
  sudo tlp start
}


