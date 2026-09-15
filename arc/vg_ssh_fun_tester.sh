
tool=vg_ssh_fun_maindocker

set -x

IFS='|'
. /usr/local/swift/bin/vg_units
. ./$tool.sh
${tool}_init

${tool}_invsend | sed "s!\$! | sed 's/^/A${tool}Z/'!" \
| ksh | while read -r line; do
    [[ $line != A*Z* ]] && continue
    tool=${line%%Z*}
    tool=${tool#A}
    rest=${line##A"$tool"Z}
    ${tool}_invreceive "$rest"
done > inv.txt

while read j1 j2 aid id name rest; do
  [[ $id == si_sz* ]] && continue
  id=${id#si_dockerid}
  unset as
  typeset -A as

  as[var]=cpu_used
  as[inst]=$id
  inst=$id
  name=cpu_used.$id
  type=number
  unit=%
  ${tool}_add

  as[var]=memory_used
  as[inst]=$id
  inst=$id
  name=memory_used.$id
  type=number
  unit=GB
  ${tool}_add

  as[var]=tcpip_inbyte
  as[inst]=$id
  inst=$id
  name=tcpip_inbyte.$id
  type=number
  unit=MB
  ${tool}_add

  as[var]=tcpip_outbyte
  as[inst]=$id
  inst=$id
  name=tcpip_outbyte.$id
  type=number
  unit=MB
  ${tool}_add

done < inv.txt

vars=()

${tool}_send | sed "s!\$! | sed 's/^/A${tool}Z/'!" \
| ksh | while read -r line; do
    [[ $line != A*Z* ]] && continue
    tool=${line%%Z*}
    tool=${tool#A}
    rest=${line##A"$tool"Z}
    ${tool}_receive "$rest"
done

${tool}_emit

print "$vars"
