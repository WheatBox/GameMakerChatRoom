
var su = draw.su,
	sx = draw.sx,
	sy = draw.sy,
	dw = draw.dw,
	dh = draw.dh;
	
if (!surface_exists(su)) {
	su = surface_create(dw + 1, dh + 1);
	draw.su = su;
	draw.re = true;
}

draw_set_color(draw.co);
draw_rectangle(sx - 1, sy - 1, sx + dw + 1, sy + dh + 1, true);

if (draw.re) {

	var co = draw.co,
		ox = draw.ox,
		oy = draw.oy,
		lh = draw.lh,
		li = curt.li,
		ls = curt.ls,
		cl = curt.cl,
		cu = curt.cu,
		cy = curt.mu ? 0 : (dh - lh) / 2;
		
	surface_set_target(su);
	draw_clear_alpha(co, 0);
	
	draw_set_font(draw.ft);
	draw_set_color(co);
	draw_set_alpha(1);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);

	#region draw text

		if (ls == 1 && li[0] == "") {
			draw_set_alpha(0.6);
			draw_text(-ox, cy + draw.ry, curt.ph);
			draw_set_alpha(1);
		} else {
			var sl = curt.sl,
				se = curt.se,
				i = floor(oy / lh),
				l = min(ls - i, ceil(dh / lh));
			if (se > -1) {
				var l0 = sl, l1 = cl, c0 = se, c1 = cu;
				if (sl > cl) { l0 = cl; l1 = sl; c0 = cu; c1 = se; }
			}
			repeat (l) {
				var tx = li[i],
					dy = i * lh - oy + cy;
				if (se > -1 && i >= l0 && i <= l1) {
					var d0 = 0, d1 = 0, ey = dy + lh - 1;
					if (l0 == i && l1 == i) {
						d0 = string_width(string_copy(tx, 1, c0)) - ox;
						d1 = string_width(string_copy(tx, 1, c1)) - ox;
						ey += 1;
					} else if (l0 == i) {
						d0 = string_width(string_copy(tx, 1, c0)) - ox;
						d1 = string_width(tx) - ox;
					} else if (l1 == i) {
						d0 = 0;
						d1 = string_width(string_copy(tx, 1, c1)) - ox;
						ey += 1;
					} else {
						d0 = 0;
						d1 = string_width(tx) - ox;
					}
					draw_set_alpha(0.6);
					draw_rectangle(d0, dy, d1, ey, false);
					draw_set_alpha(1);
				}
				draw_text(-ox, dy + draw.ry, tx);
				i ++;
			}
		}

	#endregion
	
	#region draw cursor

		if (curt.fo && draw.dc > 0) {
			var dx = string_width(string_copy(li[cl], 1, cu)) - ox,
				dy = cl * lh - oy + cy;
			draw_rectangle(dx, dy, dx, dy + lh, false);
		}

	#endregion
	
	#region draw scrollbar
	
		var th = ls * lh;
		if (th > dh) {
			var sh = max(lh, dh / th * dh),
				dy = oy / (th - dh) * (dh - sh);
			draw_set_alpha(0.6);
			draw_rectangle(dw - draw.sw, dy, dw, dy + sh, false);
			draw_set_alpha(1);
			draw.sh = sh;
			draw.dy = dy;
		}
		

	#endregion

	surface_reset_target();
	draw.re = false;

}

draw_surface(su, sx, sy);