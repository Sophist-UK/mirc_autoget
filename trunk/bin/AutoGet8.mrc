alias ag8.dll { return $+(",$scriptdir,autoget8.dll") }

alias F8 dll $ag8.dll Show

;temp!!!
alias sF8 dll -u $ag8.dll


;; returns net:channel,...
alias AG8.GetChannels {
  var %cnter = 1, %channels, %cnter2 = 1
  while (%cnter <= $scon(0)) {
    scon %cnter
    %cnter2 = 1
    while (%cnter2 <= $chan(0)) {
      %channels = $addtok(%channels, $+($scon(%cnter).$network,:,$chan(%cnter2)),44)
      inc %cnter2
    }
    inc %cnter
  }
  return $sorttok(%channels,44,a)
}

