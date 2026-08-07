--[[
#//*********************************************************//#
#//# Author: by uriid1                                     #//#
#//# license: GNU GPL                                      #//#
#//# telegram: uriid1                                      #//#
#//# Mail: appdurov@gmail.com                              #//#
#//# URL: https://microvolnovka.itch.io/easing-functions   #//#
####*******************************************************####
--]]

local c1 = 1.70158
local c2 = c1 * 1.525
local c3 = c1 + 1
local c4 = (2 * math.pi) / 3
local c5 = (2 * math.pi) / 4.5

local n1 = 7.5625
local d1 = 2.75

return {
  ------- LINEAR -------
	["linear"] = function(t)
		return t
	end,
  ----------------------

  ------- SINE -------
  ["in_sine"] = function(t)
    return math.sin((math.pi/2) * t)
  end,

  ["out_sine"] = function(t)
    return math.sin((t * math.pi) / 2)
  end,

  ["in_out_sine"] = function(t)
    return -(math.cos(math.pi * t) - 1) / 2
  end,
  ----------------------

  ------- CUBIC -------
  ["in_cubic"] = function(t)
    return t * t * t
  end,

  ["out_cubic"] = function(t)
    return 1 - math.pow(1 - t, 3)
  end,

  ["in_out_cubic"] = function(t)
    return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
  end,
  ----------------------

  ------- QUINT -------
  ["in_quint"] = function(t)
    return t * t * t * t * t
  end,

  ["out_quint"] = function(t)
    return 1 - math.pow(1 - t, 5)
  end,

  ["in_out_quint"] = function(t)
    return t < 0.5 and 16 * t * t * t * t * t or 1 - math.pow(-2 * t + 2, 5) / 2
  end,
  ----------------------

  ------- CIRC -------
  ["in_circ"] = function(t) 
    return 1 - math.sqrt(1 - math.pow(t, 2))
  end,

  ["out_circ"] = function(t)
    return math.sqrt(1 - math.pow(t - 1, 2))
  end,

  ["in_out_circ"] = function(t)
    return t < 0.5
                  and (1 - math.sqrt(1 - math.pow(2 * t, 2))) / 2
                  or (math.sqrt(1 - math.pow(-2 * t + 2, 2)) + 1) / 2
  end,
  ----------------------

  ------- ELASTIC -------
  ["in_elastic"] = function(t)
      return t == 0
                  and 0
                  or t == 1
                  and 1
                  or -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
  end,

  ["out_elastic"] = function(t)
    return t == 0
                and 0
                or t == 1
                and 1
                or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
  end,

  ["in_out_elastic"] = function(t)
      return t == 0
                  and 0
                  or t == 1
                  and 1
                  or t < 0.5
                  and -(math.pow(2, 20 * t - 10) * math.sin((20 * t - 11.125) * c5)) / 2
                  or (math.pow(2, -20 * t + 10) * math.sin((20 * t - 11.125) * c5)) / 2 + 1
  end,
  ----------------------

  ------- QUAD -------
  ["in_quad"] = function(t)
    return t * t
  end,

  ["out_quad"] = function(t)
    return 1 - (1 - t) * (1 - t)
  end,

  ["in_out_quad"] = function(t)
    return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
  end,
  ----------------------

  ------- QUART -------
  ["in_quart"] = function(t) 
    return t * t * t * t
  end,

  ["out_quart"] = function(t)
    return 1 - math.pow(1 - t, 4)
  end,

  ["in_out_quart"] = function(t)
    return t < 0.5 and 8 * t * t * t * t or 1 - math.pow(-2 * t + 2, 4) / 2
  end,
  ----------------------

  ------- EXPO -------
  ["in_expo"] = function(t)
    return t == 0 and 0 or math.pow(2, 10 * t - 10)
  end,

  ["out_expo"] = function(t)
    return t == 1 and 1 or 1 - math.pow(2, -10 * t)
  end,

  ["in_out_expo"] = function(t)
      return t == 0
                  and 0
                  or t == 1
                  and 1
                  or t < 0.5 and math.pow(2, 20 * t - 10) / 2
                  or (2 - math.pow(2, -20 * t + 10)) / 2
  end,
  ----------------------

  ------- BACK -------
  ["in_back"] = function(t)
    return c3 * t * t * t - c1 * t * t
  end,

  ["out_back"] = function(t)
    return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
  end,

  ["in_out_back"] = function(t)
    return t < 0.5
                and (math.pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2
                or (math.pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
  end,
  ----------------------

  ------- BOUNCE -------
  ["in_bounce"] = function(t)
    return math.pow(2, 6 * (t - 1)) * math.abs(math.sin(t * math.pi * 3.5))
  end,
                  
  ["out_bounce"] = function(t)
    return 1 - math.pow(2, -6 * t) * math.abs(math.cos(t * math.pi * 3.5))
  end,

  ["in_out_bounce"] = function(t)
    if (t < 0.5) then
      return 8 * math.pow(2, 8 * (t - 1)) * math.abs(math.sin( t * math.pi * 7))
    else
      return 1 - 8 * math.pow(2, -8 * t) * math.abs(math.sin( t * math.pi * 7))
    end
  end,
  ----------------------
}

