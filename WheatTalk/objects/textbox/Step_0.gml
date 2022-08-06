var mx = mouse_x,
	my = mouse_y,
	dw = draw.dw,
	dh = draw.dh,
	sx = draw.sx,
	sy = draw.sy,
	sw = curt.mu ? draw.sw : 0,
	vi = point_in_rectangle(mx, my, sx, sy, sx + dw - sw, sy + dh);

if (vi != curt.vi) {
	window_set_cursor(vi ? cr_beam : cr_default);
	curt.vi = vi;
}

var dc = draw.dc - 1;
if (dc < -30) {
	dc = 30;
	draw.re = true;
} else if (dc == 0) {
	draw.re = true;
}

draw.dc = dc;

var input_en = keyboard_check_pressed(vk_enter),
	input_ml = mouse_check_button_pressed(mb_left),
	input_mp = mouse_check_button(mb_left),
	input_mr = mouse_check_button_released(mb_left),
	input_sh = keyboard_check(vk_shift);

#region update cursor (with mouse)
	
	if (input_ml) {
		
		curt.fo = vi;
		curt.se = -1;
		draw.dc = vi ? 30 : 0;
		draw.re = true;
		
		if (vi) {
			keyboard_string = "";
			textbox_check_minput(input_sh);
			curt.br = 5;
		} else {
			var th = curt.ls * draw.lh;
			if (th > dh) {
				var rb = sx + dw;
				if (!point_in_rectangle(mx, my, rb - sw, sy, rb, sy + dh)) return;
				var dy = draw.dy,
					sh = draw.sh,
					ty = sy + dy;
				if (my >= ty && my <= ty + sh) {
					draw.my = mouse_y;
				} else {
					var ch = dh - sh;
					dy = my - sy;
					if (dy < sh) dy = 0;
					else if (dy > ch) dy = ch;
					draw.oy = dy / ch * (th - dh);
					draw.my = my;
					draw.re = true;
				}
			}
			return;
		}
		return;
	}
	
	if (draw.my > 0) {
		if (input_mr) draw.my = 0;
		else if (input_mp) {
			curt.br --;
			if (curt.br < 0) {
				var dy = draw.dy,
					ch = dh - draw.sh;
				dy = clamp(dy + my - draw.my, 0, ch);
				draw.oy = dy / ch * (curt.ls * draw.lh - dh);
				draw.my = my;
				draw.re = true;
				curt.br = 1;
			}
		}
	}

#endregion

#region update offset (with mouse)

	if (vi) {

		var input_md = mouse_wheel_down(),
			input_mu = mouse_wheel_up();
	
		var mc = input_mu - input_md;
		if (mc != 0) {
			if (curt.mu) {
				// Update y-offset.
				var lh = draw.lh,
					oy = draw.oy - lh * mc,
					mh = curt.ls * lh - dh;
				if (mh < 0) oy = 0;
				else oy = clamp(oy, 0, mh);
				draw.oy = oy;
			} else {
				// Update x-offset.
				draw_set_font(draw.ft);
				var ox = draw.ox - draw.lh * mc,
					mw = string_width(curt.li[0]) - dw;
				if (mw < 0) ox = 0;
				else ox = clamp(ox, 0, mw);
				draw.ox = ox;
			}
			draw.re = true;
			return;
		}

	}

#endregion

if (curt.fo) {
	
		input_ho = keyboard_check_pressed(vk_home);
		input_ed = keyboard_check_pressed(vk_end);
		input_bs = keyboard_check_pressed(vk_backspace);
		input_de = keyboard_check_pressed(vk_delete);
		input_pb = keyboard_check(vk_backspace);
		input_pe = keyboard_check(vk_delete);
		input_ct = keyboard_check(vk_control);
		input_na = keyboard_check_pressed(ord("A"));
		input_nx = keyboard_check_pressed(ord("X"));
		input_nc = keyboard_check_pressed(ord("C"));
		input_nv = keyboard_check_pressed(ord("V"));
		input_nz = keyboard_check_pressed(ord("Z"));
		input_ny = keyboard_check_pressed(ord("Y"));
		input_le = keyboard_check_pressed(vk_left);
		input_ri = keyboard_check_pressed(vk_right);
		input_pl = keyboard_check(vk_left);
		input_pr = keyboard_check(vk_right);
		input_up = keyboard_check_pressed(vk_up);
		input_dw = keyboard_check_pressed(vk_down);
		input_pu = keyboard_check(vk_up);
		input_pd = keyboard_check(vk_down);
	
	if(input_de_chan == false) {
		input_de = true;
		input_de_chan = true;
	}
	if(keyboard_check_pressed(vk_enter) || (keyboard_check(vk_alt) && keyboard_check_pressed(ord("S")))) {
		input_ct = true;
		input_na = true;
		input_de_chan = false;
	}
	
	#region get string
	
		var ks = keyboard_string;
		if (ks != "") {
			textbox_insert_string(ks);
			keyboard_string = "";
			return;
		}
	
	#endregion
	
	#region update mouse selector
	
		if (input_mp) {
			curt.br --;
			if (curt.br < 0) {
				textbox_check_minput(true);
				curt.br = 3;
			}
			return;
		}
	
	#endregion
	
	#region break line
	
		if (input_en && !curt.nw) {
			curt.se = -1;
			textbox_break_line();
			return;
		}
	
	#endregion
	
	#region update cursor
			
		var hc = input_ri - input_le;
		if (hc != 0) {
			curt.br = 40;
			textbox_update_cursor(hc, input_sh, false);
		}
		
		var ph = input_pr - input_pl;
		if (ph != 0) {
			curt.br --;
			if (curt.br < 0) {
				textbox_update_cursor(ph, input_sh, false);
				curt.br = 3;
			}
			return;
		}
		
		if (curt.mu) {

			var vc = input_dw - input_up;
			if (vc != 0) {
				curt.br = 40;
				textbox_update_cursor(vc, input_sh, true);
			}
		
			var pv = input_pd - input_pu;
			if (pv != 0) {
				curt.br --;
				if (curt.br < 0) {
					textbox_update_cursor(pv, input_sh, true);
					curt.br = 3;
				}
				return;
			}
		
		}
	
	#endregion

	#region delete string

		if (input_bs || input_de) {
			curt.br = 40;
			textbox_delete_string(input_de);
		}

		if (input_pb || input_pe) {
			curt.br --;
			if (curt.br < 0) {
				textbox_delete_string(input_pe);
				curt.br = 3;
			}
			return;
		}

	#endregion
	
	#region edit string
	
		if (input_ct) {

			// Select all string.
			if (input_na) {
				var ls = curt.ls - 1,
					le = string_length(curt.li[ls]);
				if (ls < 1 && le < 1) return;
				curt.sl = 0;
				curt.se = 0;
				curt.cl = ls;
				curt.cu = le;
				textbox_refresh_surface();
				return;
			}
			
			// Copy string.
			if (input_nc) {
				textbox_copy_string();
				return;
			}
			
			// Cut string.
			if (input_nx) {
				textbox_copy_string();
				textbox_delete_string(false);
				return;
			}

			// Paste string.
			if (input_nv) {
				var cl = clipboard_has_text() ? clipboard_get_text() : global.clipboard;
				if (cl != "") textbox_insert_string(cl);
				return;
			}
			
			// Undo.
			if (input_nz) {
				textbox_records_set(-1);
				return;
			}
			
			// Redo.
			if (input_ny) {
				textbox_records_set(1);
				return;
			}
			
		}
	
	#endregion
	
	#region others
	
		// Go to the beginning.
		if (input_ho) {
			if (input_sh) {
				curt.sl = curt.cl;
				curt.se = curt.cu;
			} else curt.se = -1;
			if (input_ct) curt.cl = 0;
			curt.cu = 0;
			textbox_refresh_surface();
			return;
		}
			
		// Go to the end.
		if (input_ed) {
			if (input_sh) {
				curt.sl = curt.cl;
				curt.se = curt.cu;
			} else curt.se = -1;
			if (input_ct) curt.cl = curt.ls - 1;
			curt.cu = string_length(curt.li[curt.cl]);
			textbox_refresh_surface();
			return;
		}
	
	#endregion

}