function fl_brains.fish_brain(self)
    --stuff

    if self.hp <= 0 then --kill self if 0 hp
        local item_drops = fl_wildlife.drops(self.drops)
        if item_drops ~= nil then
            for _, i in pairs(item_drops) do
                minetest.add_item(mobkit.get_stand_pos(self), i)
            end
        end

        mobkit.clear_queue_high(self)
        fl_wildlife.hq_die(self)
        return
    end

    if mobkit.timer(self,1) then
        mobkit.animate(self,"walk")
        mobkit.hq_aqua_roam(self,10,1)
    end
end