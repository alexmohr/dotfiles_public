#!/bin/bash
# Fugly script to create named workspaces and rename existing ones
dmenu="rofi -theme Arc-Dark -dmenu -i -fn 'FontAwesome-10' -nb #212121 -sf #fafafa -sb #3f51b5 -nf #fafafa -p"

new=" (new)"
existingSpaces=`i3-msg -t get_workspaces |  tr , '\n' | grep name |    cut -d \" -f 4 `

allSpaces=$existingSpaces
for i in {1..10}
do
  if [[ "$existingSpaces" != *"$i"* ]]; then
    allSpaces=$allSpaces\\n$i$new
  fi
done

workspaceNumber=`echo -e "$allSpaces" | $dmenu "Edit workspace"`

# no workspace set
if [[ -z "$workspaceNumber" ]]; then
  exit 1 
fi

workspaceName=`echo -e "" | $dmenu "Create Workspace, name?"`
workspaceNumber=`echo $workspaceNumber | sed "s/$new//g"`
echo $workspaceNumber


# rename or create workspace
if [[ "$existingSpaces" == *"$workspaceNumber"* ]]; then
  newWorkspaceNumber=`echo $workspaceNumber | cut -d \: -f 1`
  # no name set
  if [[ -z "$workspaceName" ]]; then
    i3-msg rename workspace \""$workspaceNumber"\" to \""$newWorkspaceNumber"\"
  else
    i3-msg rename workspace \""$workspaceNumber"\" to \""$newWorkspaceNumber:$workspaceName"\"
  fi
else
  if [ -z "$VAR" ]; then
    i3-msg workspace \""$workspaceNumber"\"
  else
    i3-msg workspace \""$workspaceNumber:$workspaceName"\"
  fi
fi





