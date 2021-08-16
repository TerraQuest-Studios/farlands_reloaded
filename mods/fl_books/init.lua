minetest.register_craftitem("fl_books:book_raw", {
    description = "raw book",
    inventory_image = "farlands_book_raw.png",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        --minetest.chat_send_all("test")
        local formspec = {
            "formspec_version[4]",
            "size[10.4,14.7]",
            "no_prepend[]",
            --background
            "bgcolor[black;neither]",
            "background9[0,0;10.4,11.3;i3_bg_full.png;false;10]",
            "background9[0.5,0.5;9.4,10.3;i3_slot.png;false;10]",
            --body
            "style_type[textarea;noclip=false]",
            "textarea[1,2;3,3;test;test1;test2]",
            --bottom buttons
            "style_type[image_button;bgimg=i3_btn9.png;bgimg_hovered=i3_btn9_hovered.png;",
                "bgimg_pressed=i3_btn9_pressed.png;bgimg_middle=4,6;noclip=true;border=false;bgcolor=#ffffff00]",
            --"style[i3_btn9.png;bgimg_hovered=i3_btn9_hovered.png]",
            "image_button[0.5,12;3,1;i3_btn9.png;sign_btn;sign]",
            "image_button[7,12;3,1;i3_btn9.png;write_btn;write]",
        }
        minetest.show_formspec(user:get_player_name(), "fl_books:book_raw", table.concat(formspec, ""))
    end
})

minetest.register_craftitem("fl_books:book_written", {
    description = "written book",
    stack_max = 1,
    inventory_image = "farlands_book_written.png"
})

minetest.register_craftitem("fl_books:book_signed", {
    description = "signed book",
    stack_max = 1,
    inventory_image = "farlands_book_signed.png"
})