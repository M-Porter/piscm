# Return 0 (true) when the shortcut aliases and their completions are active,
# i.e. PISCM_AUTO_ALIAS is not explicitly set to "off".
# Lives in functions/ so fish autoloads it on demand during tab completion,
# independent of conf.d sourcing.
function __piscm_auto_alias_active
    test "$PISCM_AUTO_ALIAS" != "off"
end
