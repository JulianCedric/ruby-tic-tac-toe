module Regexps
  def regexps(player)
    [/#{player.mark}\-#{player.mark}/, # "X-X"
     /#{player.mark}#{player.mark}\-/, # "XX-"
     /\-#{player.mark}#{player.mark}/, # "-XX"
     /#{player.mark}\-\-/,             # "X--"
     /\-#{player.mark}\-/,             # "-X-"
     /\-\-#{player.mark}/]             # "--X"
  end
end
