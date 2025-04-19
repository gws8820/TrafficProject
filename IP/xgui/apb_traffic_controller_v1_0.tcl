# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CTRL_INDEX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STATUS_INDEX" -parent ${Page_0}


}

proc update_PARAM_VALUE.CTRL_INDEX { PARAM_VALUE.CTRL_INDEX } {
	# Procedure called to update CTRL_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_INDEX { PARAM_VALUE.CTRL_INDEX } {
	# Procedure called to validate CTRL_INDEX
	return true
}

proc update_PARAM_VALUE.STATUS_INDEX { PARAM_VALUE.STATUS_INDEX } {
	# Procedure called to update STATUS_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STATUS_INDEX { PARAM_VALUE.STATUS_INDEX } {
	# Procedure called to validate STATUS_INDEX
	return true
}


proc update_MODELPARAM_VALUE.CTRL_INDEX { MODELPARAM_VALUE.CTRL_INDEX PARAM_VALUE.CTRL_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CTRL_INDEX}] ${MODELPARAM_VALUE.CTRL_INDEX}
}

proc update_MODELPARAM_VALUE.STATUS_INDEX { MODELPARAM_VALUE.STATUS_INDEX PARAM_VALUE.STATUS_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STATUS_INDEX}] ${MODELPARAM_VALUE.STATUS_INDEX}
}

