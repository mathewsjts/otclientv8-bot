macro(250, "rune maker", function()
  if not isInPz() and freecap() > 100 then
    local runes_list = {
      gfb = { id = 3191, casting = "adori mas flam" },
      ava = { id = 3161, casting = "adori mas frigo" },
      tds = { id = 3202, casting = "adori mas vis" },
      ssr = { id = 3175, casting = "adori mas tera" }
    }
    local rune_maker = "tds"
    local rune_count = itemAmount(runes_list[rune_maker]["id"])

    if rune_count < 100 then
      stg_custom.set_data("macro_rune_maker", true)
    end

    if rune_count > 350 then
      stg_custom.set_data("macro_rune_maker", false)
    end

    if not storage_custom.macro_rune_maker then
      return
    end

    if itemAmount(3147) < 1 then
      cast("adori blank")
      return
    end
    cast(runes_list[rune_maker]["casting"])
  end
end)
