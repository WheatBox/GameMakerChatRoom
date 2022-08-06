
/// @param string
function format_nowrap(s) {
	
	var r = string_replace_all(s, "\n", "");
		r = string_replace_all(r, "\r", "");
		r = string_replace_all(r, "\t", "");

	return r;

}

/// @param string
function format_newline(s) {
	
	var r = string_replace_all(s, "\r", "");
		r = string_replace_all(r, "\t", "");
		
	return r;

}

/// @param array
function lines_to_text(a) {
	
	var t = a[0],
		i = 1,
		l = array_length(a) - 1;

	repeat (l) {
		t += "\n" + a[i];
		i ++;
	}
	
	return t;

}

/// @param string
function text_to_lines(s) {

	var a = [],
		t = s,
		p = string_pos("\n", t);

	while (p > 0) {
	    array_push(a, string_copy(t, 1, p - 1));
	    t = string_delete(t, 1, p);
	    p = string_pos("\n", t);
	}

	array_push(a, t);
	return a;

}

/// @param x
/// @param y
/// @param width
/// @param height
/// @param initial_text
/// @param placeholder
/// @param max_length
/// @param nowrap
/// @param adaptive_width
function textbox_create(x, y, w, h, n, p, m, b, a) {

	var i = instance_create_depth(0, 0, depth - 1, textbox);
	with (i) {
		draw.sx = x;					// x
		draw.sy = y;					// y
		draw.dw = w;					// width
		draw.dh = h;					// height
		curt.ph = p;					// placeholder
		curt.ml = m;					// max length
		curt.nw = b;					// nowrap
		curt.aw = a;					// adaptive width
		if (b && !a) curt.mu = false;
		textbox_insert_string(n);
	}

	return i;

}

/// @param instance
/// @param font_index
/// @param font_color
/// @param line_height
/// @param y_resive
function textbox_set_font(i, f, c, l, r) {

	with (i) {
		draw.ft = f;					// font
		draw.co = c;					// font color
		draw.lh = l;					// line height
		draw.ry = r;					// y resive
		textbox_refresh_surface();
	}

}

/// @param instance
/// @param x
/// @param y
/// @param offset?
function textbox_set_position(i, x, y, o) {

	with (i) {
		if (o) {
			draw.sx += x;				// +x
			draw.sy += y;				// +y
		} else {
			draw.sx = x;				// x
			draw.sy = y;				// y
			draw.re = true;
		}
	}

}

/// @param instance
function textbox_return(i) {
	
	var tx = "";
	with (i) {
		tx = lines_to_text(curt.li);
		if (curt.aw) tx = textbox_close_lines(tx, 0);
	}
	
	return tx;

}
	
/// @param current_line
/// @param cursor
function textbox_records_add(l, c) {
		
	var hr = curt.hr,
		cr = curt.cr + 1;

	if (cr < array_length(hr)) array_resize(hr, cr);
	array_push(hr, [lines_to_text(curt.li), l, c, string(curt.lb)]);
		
	if (array_length(hr) > curt.rl) {
		array_delete(hr, 0, 1);
		cr -= 1;
	}

	curt.cr = cr;

}

/// @param current_line
/// @param cursor
function textbox_records_rec(l, c) {
	
	var li = curt.hr[curt.cr];
	li[@ 1] = l;
	li[@ 2] = c;

}

/// @param change
function textbox_records_set(c) {
	
	var hr = curt.hr,
		cr = curt.cr + c;
		
	if (cr < 0 || cr >= array_length(hr)) return;
	
	var li = hr[cr],
		ar = text_to_lines(li[0]),
		lb = [],
		ct = li[3],
		le = string_length(ct);
		ct = string_copy(ct, 3, le - 2);
		
	var i = 1,
		l = (le - 3) / 2;
		
	repeat (l) {
		array_push(lb, real(string_copy(ct, i, 1)));
		i += 2;
	}
	
	curt.li = ar;
	curt.lb = lb;
	curt.cr = cr;
	curt.cl = li[1];
	curt.cu = li[2];
	curt.se = -1;
	curt.ls = array_length(ar);
	textbox_refresh_surface();
	
}

function textbox_refresh_surface() {

	var cl = curt.cl,
		tx = curt.li[cl],
		cu = curt.cu,
		lh = draw.lh,
		dw = draw.dw,
		dh = draw.dh - lh;
		
	// Update y-offset.
	if (curt.mu) {
		var oy = draw.oy,
			ch = cl * lh,
			oh = ch - oy;
		if (oh < 0) oy = max(0, ch);
		else if (oh > dh) oy = ch - dh;
		var mh = curt.ls * lh - dh;
		if (mh < 0) oy = 0;
		else oy = clamp(oy, 0, mh);
		draw.oy = oy;
		dw -= draw.sw;
	}

	// Update x-offset.
	if (!curt.aw) {
		draw_set_font(draw.ft);
		var ox = draw.ox,
			cw = string_width(string_copy(tx, 1, cu)),
			ow = cw - ox;	
		if (ow < 0) ox = cw;
		else if (ow > dw) ox = cw - dw;
		var mw = string_width(tx) - dw;
		if (mw < 0) ox = 0;
		else ox = clamp(ox, 0, mw);
		draw.ox = ox;
	}
	
	draw.dc = 30;
	draw.re = true;

}

function textbox_max_length() {

	var ml = curt.ml;
	if (ml > 0) {
		var li = curt.li,
			ct = lines_to_text(li);
		if (string_length(ct) - string_count("\n", ct) > ml) {
			var lb = curt.lb,
				cl = curt.cl,
				i = 0,
				l = curt.ls;
			repeat (l) {
				ct = li[i];
				var sl = string_length(ct);
				if (sl >= ml) {
					array_delete(li, i + 1, l - i - 1);
					array_delete(lb, i + 1, l - i - 1);
					li[@ i] = string_copy(ct, 1, ml);
					break;
				} else ml -= sl;
				i ++;
			}
			if (cl > i) {
				curt.cl = i;
				curt.cu = ml;
			} else if (cl == i && curt.cu > ml) {
				curt.cu = ml;
			}
			curt.ls = i + 1;
		}
	}

}

/// @param string
function textbox_insert_string(s) {
		
	if (curt.se > -1) textbox_delete_string(false);
		
	var li = curt.li,
		lb = curt.lb,
		cl = curt.cl,
		cu = curt.cu,
		aw = curt.aw,
		ns = curt.nw ? format_nowrap(s) : format_newline(s),
		nl = string_length(ns);
	
	if (string_pos("\n", ns) < 1) {
		li[@ cl] = string_insert(ns, li[cl], cu + 1);
		curt.cu += nl;
		if (aw) textbox_break_lines(cl, 1, nl + cu, 0);
	} else {
		var ol = cl,
			ct = li[ol],
			lt = string_length(ct),
			ad = text_to_lines(ns),
			le = array_length(ad) - 1,
			i = le;
		cl = ol + le;
		repeat (le) {
			array_insert(li, ol + 1, ad[i]);
			array_insert(lb, ol + 1, true);
			i --;
		}
		if (cu == lt) cu = string_length(li[cl]);
		else {
			var nt = ad[le];
			li[@ cl] = nt + string_copy(ct, cu + 1, lt - cu);
			ct = string_copy(ct, 1, cu);
			cu = string_length(nt);
		}
		li[@ ol] = ct + ad[0];
		curt.cl = cl;
		curt.cu = cu;
		if (aw) {
			var sl = nl - string_count("\n", ns) + string_length(ct),
				nc = 0,
				cn = string_copy(ns, nl, 1);
			while (nl > 1 && cn == "\n") {
				nl -= 1;
				nc += 1;
				cn = string_copy(ns, nl, 1);
			}
			textbox_break_lines(ol, le + 1, sl, nc);
		}
	}
	
	curt.ls = array_length(li);
	textbox_max_length();
	textbox_records_add(curt.cl, curt.cu);
	textbox_refresh_surface();

}

/// @param delete_key?
function textbox_delete_string(d) {

	var li = curt.li,
		lb = curt.lb,
		cl = curt.cl,
		cu = curt.cu,
		sl = curt.sl,
		se = curt.se;

	if (se > -1) {
		if (sl == cl) {
			var co = abs(cu - se);
				cu = min(cu, se);
			li[@ cl] = string_delete(li[cl], cu + 1, co);
		} else {
			var l0 = min(cl, sl), c0 = se, c1 = cu;
			if (sl > cl) { c0 = cu; c1 = se; }
			var le = abs(cl - sl),
				ct = string_delete(li[l0 + le], 1, c1);
			li[@ l0] = string_copy(li[l0], 1, c0) + ct;
			array_delete(li, l0 + 1, le);
			array_delete(lb, l0 + 1, le);
			cl = l0;
			cu = c0;
		}
		curt.se = -1;
	} else {
		var ct = li[cl];
		if (d) {
			if (cu == string_length(ct)) {
				if (cl == curt.ls - 1) return;
				li[@ cl] = ct + li[cl + 1];
				array_delete(li, cl + 1, 1);
				array_delete(lb, cl + 1, 1);
			} else {
				li[@ cl] = string_delete(ct, cu + 1, 1);
			}
		} else {
			if (cu == 0) {
				if (cl == 0) return;
				array_delete(li, cl, 1);
				array_delete(lb, cl, 1);
				cl -= 1;
				var nt = li[cl];
				cu = string_length(nt);
				li[@ cl] = nt + ct;
			} else {
				li[@ cl] = string_delete(ct, cu, 1);
				cu -= 1;
			}
		}
	}
	
	curt.cl = cl;
	curt.cu = cu;
	curt.ls = array_length(li);
	if (curt.aw) textbox_break_lines(cl, 1);
	textbox_records_add(cl, cu);
	textbox_refresh_surface();

}

function textbox_copy_string() {
	
	var se = curt.se;
	if (se < 0) return;
	
	var li = curt.li,
		cl = curt.cl,
		cu = curt.cu,
		sl = curt.sl,
		tx = "";
	
	if (cl == sl) {
		tx = string_copy(li[cl], min(cu, se) + 1, abs(cu - se));
	} else {
		var ar = [], l0 = min(cl, sl), c0 = se, c1 = cu;
		if (sl > cl) { c0 = cu; c1 = se; }
		var le = abs(cl - sl);
		array_copy(ar, 0, li, l0, le + 1);
		ar[0] = string_delete(ar[0], 1, c0);
		ar[le] = string_copy(ar[le], 1, c1);		
		tx = lines_to_text(ar);
		if (curt.aw) tx = textbox_close_lines(tx, l0);
	}
	
	global.clipboard = tx;
	clipboard_set_text(tx);

}
	
function textbox_break_line() {

	var li = curt.li,
		cl = curt.cl,
		tx = li[cl],
		le = string_length(tx),
		cu = curt.cu;
	
	cl += 1;
	if (cu < le) {
		var be = cu + 1,
			co = le - cu;
		li[@ cl - 1] = string_delete(tx, be, co);
		array_insert(li, cl, string_copy(tx, be, co));
	} else {
		array_insert(li, cl, "");
	}
	
	array_insert(curt.lb, cl, true);

	curt.cl = cl;
	curt.cu = 0;
	curt.ls = array_length(li);
	if (curt.aw) textbox_break_lines(cl, 1);
	textbox_records_add(cl, 0);
	textbox_refresh_surface();

}

/// @param start_line
/// @param count
/// @param length
/// @param \n_length
function textbox_break_lines(i, c, l = 0, n = 0) {
	
	var dw = draw.dw - draw.sw,
		li = curt.li,
		lb = curt.lb,
		le = l,
		i0 = i,
		l0 = i + c;
		
	while (i0 < l0) {
		var ct = li[i0],
			cw = string_width(ct);
		if (cw > dw) {
			var i1 = 1,
				l1 = string_length(ct);
			repeat (l1) {
				if (string_width(string_copy(ct, 1, i1)) > dw) {
					array_insert(li, i0 + 1, string_delete(ct, 1, i1 - 1));
					array_insert(lb, i0 + 1, false);
					li[@ i0] = string_copy(ct, 1, i1 - 1);
					break;
				}
				i1 ++;
			}
			l0 += 1;
		} else {
			var nl = i0 + 1;
			if (nl < array_length(lb) && !lb[nl]) {
				var nt = li[nl],
					nw = string_width(nt);
				if (cw + nw <= dw) {
					li[@ i0] = ct + nt;
					array_delete(li, nl, 1);
					array_delete(lb, nl, 1);
					l0 -= 1;
				} else {
					var i1 = 1,
						l1 = string_length(nt);
					repeat (l1) {
						if (cw + string_width(string_copy(nt, 1, i1)) > dw) {
							li[@ i0] = ct + string_copy(nt, 1, i1 - 1);
							li[@ nl] = string_delete(nt, 1, i1 - 1);
							break;
						}
						i1 ++;
					}
					l0 += 1;
				}
			}
		}
		if (le > 0) {
			ct = li[i0];
			var sl = string_length(ct);
			if (sl >= le) {
				curt.cl = i0 + n;
				curt.cu = n > 0 ? 0 : le;
				le = 0;
			} else le -= sl;
		}
		i0 ++;
	}
	
	curt.ls = array_length(li);

}

/// @param string
/// @param start_line
function textbox_close_lines(s, i) {

	var lb = curt.lb,
		tx = s,
		ct = s,
		cp = i + 1,
		po = string_pos("\n", ct),
		le = po;
		
	while (po > 0) {
		if (!lb[cp]) {
			tx = string_delete(tx, le, 1);
			le -= 1;
		}
		ct = string_delete(ct, 1, po);
		po = string_pos("\n", ct);
		le += po;
		cp += 1;
	}
	
	return tx;

}

/// @param change
function textbox_check_hinput(c) {

	var li = curt.li,
		cl = curt.cl,
		cu = curt.cu + c,
		le = string_length(li[cl]);
		
	if (cu < 0) {
		if (cl < 1) cu = 0;
		else {
			cl -= 1;
			cu = string_length(li[cl]);
		}
	} else if (cu > le) {
		if (cl == curt.ls - 1) cu = le;
		else {
			cl += 1;
			cu = 0;
		}
	}
	
	curt.cl = cl;
	textbox_records_rec(cl, cu);
	return cu;

}

/// @param change
function textbox_check_vinput(c) {

	var cl = curt.cl,
		cu = curt.cu,
		nl = clamp(cl + c, 0, curt.ls - 1);
	
	if (nl == cl) return cu;
	draw_set_font(draw.ft);
	
	var li = curt.li,
		cw = string_width(string_copy(li[cl], 1, cu)),
		tx = li[nl],
		le = string_length(tx);
		
	if (cw >= string_width(tx)) cu = le;
	else {
		cu = 0;
		repeat (le) {
			var ra = cw - string_width(string_copy(tx, cu + 1, 1)) / 2;
			if (string_width(string_copy(tx, 1, cu)) >= ra) break;
			cu += 1;
		}
	}
	
	curt.cl = nl;
	textbox_records_rec(nl, cu);
	return cu;

}

/// @param select?
function textbox_check_minput(s) {

	draw_set_font(draw.ft);

	var lh = draw.lh,
		cl = clamp(floor((draw.oy + mouse_y - draw.sy) / lh), 0, curt.ls - 1),
		tx = curt.li[cl],
		le = string_length(tx);
	
	if (cl == curt.cl) {
		
		var cu = curt.cu,
			cw = string_width(string_copy(tx, 1, cu)) - draw.ox - mouse_x + draw.sx,
			ci = cu;
	
		if (cw < 0) {
			cw *= -1;
			if (cu == 0) cu = 1;
			repeat (le) {
				var ra = cw - string_width(string_copy(tx, ci + 1, 1)) / 2;
				if (string_width(string_copy(tx, cu, ci - cu)) >= ra) break;
				ci ++;
			}
		} else {
			repeat (le) {
				var ra = cw - string_width(string_copy(tx, ci, 1)) / 2;
				if (string_width(string_copy(tx, ci, cu - ci)) >= ra) break;
				ci --;
			}
		}
	
		cu = clamp(ci, 0, le);
	
	} else {
	
		var cw = draw.ox + mouse_x - draw.sx,
			cu = 0;
			
		if (cw >= string_width(tx)) cu = le;
		else {
			repeat (le) {
				var ra = cw - string_width(string_copy(tx, cu + 1, 1)) / 2;
				if (string_width(string_copy(tx, 1, cu)) >= ra) break;
				cu += 1;
			}
		}
	
	}
	
	if (s) {
		var sl = curt.sl,
			se = curt.se;
		if (se < 0) {
			sl = curt.cl;
			se = curt.cu;
		}
		if (cl == sl && cu == se) se = -1;
		curt.sl = sl;
		curt.se = se;
	}
	
	curt.cl = cl;
	curt.cu = cu;
	textbox_records_rec(cl, cu);
	textbox_refresh_surface();

}

/// @param change
/// @param select?
/// @param vertical?
function textbox_update_cursor(c, s, v) {
	
	if (s) {
		var cl = curt.cl,
			cu = curt.cu,
			sl = curt.sl,
			se = curt.se;
		if (se < 0) {
			sl = cl;
			se = cu;
		}
		cu = v ? textbox_check_vinput(c) : textbox_check_hinput(c);
		if (curt.cl == sl && cu == se) se = -1;
		curt.cu = cu;
		curt.sl = sl;
		curt.se = se;
	} else {
		if (curt.se > -1) {
			curt.se = -1;
			return;
		}
		curt.cu = v ? textbox_check_vinput(c) : textbox_check_hinput(c);
	}
	
	textbox_refresh_surface();

}