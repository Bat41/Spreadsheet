public class Spreadsheet.StyleModal : Gtk.Grid {
    public FontStyle font_style { get; construct; }
    public CellStyle cell_style { get; construct; }
    private Gtk.ColorButton color_button;
    private Gtk.Button color_remove_button;
    private Gtk.ColorButton bg_button;
    private Gtk.Button bg_remove_button;
    private Gtk.ColorButton sr_button;
    private Gtk.SpinButton sr_width_spin;
    private Gtk.Button sr_remove_button;

    public StyleModal (FontStyle font_style, CellStyle cell_style) {
        var style_stack = new Gtk.Stack ();
        style_stack.add_titled (fonts_grid (font_style), "fonts-grid", "Fonts");
        style_stack.add_titled (cells_grid (cell_style), "cells-grid", "Cells");

        var style_stacksw = new Gtk.StackSwitcher ();
        style_stacksw.homogeneous = true;
        style_stacksw.halign = Gtk.Align.CENTER;
        style_stacksw.stack = style_stack;

        margin = 6;
        attach (style_stacksw, 0, 0, 1, 1);
        attach (style_stack, 0, 1, 1, 1);
    }

    private Gtk.Grid fonts_grid (FontStyle font_style) {
        var fonts_grid = new Gtk.Grid ();
        fonts_grid.margin_top = 6;
        fonts_grid.column_spacing = 6;

        var color_label = new Gtk.Label ("Color");
        color_label.halign = Gtk.Align.START;
        color_label.get_style_context ().add_class ("h4");
        color_button = new Gtk.ColorButton ();
        color_button.halign = Gtk.Align.START;
        color_button.tooltip_text = "Set font color of a selected cell";
        font_style.bind_property ("fontcolor", color_button, "rgba", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        color_remove_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
        color_remove_button.halign = Gtk.Align.START;
        color_remove_button.tooltip_text = "Reset font color of a selected cell to black";

        fonts_grid.attach (color_label, 0, 0, 1, 1);
        fonts_grid.attach (color_button, 0, 1, 1, 1);
        fonts_grid.attach (color_remove_button, 1, 1, 1, 1);

        Gdk.RGBA font_default_color = { 0, 0, 0, 1 };
        color_remove_button.sensitive = check_color (color_button, font_default_color);

        color_remove_button.clicked.connect (() => {
            font_style.color_remove ();
            color_remove_button.sensitive = check_color (color_button, font_default_color);
        });
        color_button.color_set.connect (() =>{
            color_remove_button.sensitive = check_color (color_button, font_default_color);
        });

        return fonts_grid;
    }

    private Gtk.Grid cells_grid (CellStyle cell_style) {
        var cells_grid = new Gtk.Grid ();
        cells_grid.margin_top = 6;
        cells_grid.column_spacing = 6;

        var bg_label = new Gtk.Label ("Fill");
        bg_label.halign = Gtk.Align.START;
        bg_label.get_style_context ().add_class ("h4");
        bg_button = new Gtk.ColorButton ();
        bg_button.halign = Gtk.Align.START;
        bg_button.tooltip_text = "Set fill color of a selected cell";
        cell_style.bind_property ("background", bg_button, "rgba", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        bg_remove_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
        bg_remove_button.halign = Gtk.Align.START;
        bg_remove_button.tooltip_text = "Remove fill color of a selected cell";

        var sr_label = new Gtk.Label ("Stroke");
        sr_label.halign = Gtk.Align.START;
        sr_label.get_style_context ().add_class ("h4");
        sr_button = new Gtk.ColorButton ();
        sr_button.halign = Gtk.Align.START;
        sr_button.tooltip_text = "Set stroke color of a selected cell";
        cell_style.bind_property ("stroke", sr_button, "rgba", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        sr_width_spin = new Gtk.SpinButton.with_range (0.1, 3, 0.1);
        sr_width_spin.halign = Gtk.Align.START;
        sr_width_spin.tooltip_text = "Set the border width of a selected cell";
        cell_style.bind_property ("stroke_width", sr_width_spin, "value", BindingFlags.SYNC_CREATE | BindingFlags.BIDIRECTIONAL);
        sr_remove_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
        sr_remove_button.halign = Gtk.Align.START;
        sr_remove_button.tooltip_text = "Remove stroke color of a selected cell";

        cells_grid.attach (bg_label, 0, 0, 1, 1);
        cells_grid.attach (bg_button, 0, 1, 1, 1);
        cells_grid.attach (bg_remove_button, 1, 1, 1, 1);
        cells_grid.attach (sr_label, 0, 2, 1, 1);
        cells_grid.attach (sr_button, 0, 3, 1, 1);
        cells_grid.attach (sr_width_spin, 1, 3, 1, 1);
        cells_grid.attach (sr_remove_button, 2, 3, 1, 1);

        Gdk.RGBA bg_default_color = { 255, 255, 255, 0 };
        Gdk.RGBA sr_default_color = { 0, 0, 0, 0 };
        bg_remove_button.sensitive = check_color (bg_button, bg_default_color);
        sr_remove_button.sensitive = check_color (sr_button, sr_default_color);
        sr_width_spin.sensitive = check_color (sr_button, sr_default_color);

        bg_remove_button.clicked.connect (() => {
            cell_style.bg_remove ();
            bg_remove_button.sensitive = check_color (bg_button, bg_default_color);
        });
        bg_button.color_set.connect (() =>{
            bg_remove_button.sensitive = check_color (bg_button, bg_default_color);
        });
        sr_remove_button.clicked.connect (() => {
            cell_style.sr_remove ();
            sr_width_spin.value = 1.0;
            sr_remove_button.sensitive = check_color (sr_button, sr_default_color);
            sr_width_spin.sensitive = check_color (sr_button, sr_default_color);
        });
        sr_button.color_set.connect (() =>{
            sr_remove_button.sensitive = check_color (sr_button, sr_default_color);
            sr_width_spin.sensitive = check_color (sr_button, sr_default_color);
        });
        
        return cells_grid;
    }

    private bool check_color (Gtk.ColorButton bt, Gdk.RGBA dc) {
        if (bt.rgba == dc) {
            return false;
        } else {
            return true;
        }
    }
}
