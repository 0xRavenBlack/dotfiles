import gi
import datetime

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk

# Updated Dracula theme CSS with proper alignment and selection fixes
DRACULA_CSS = """
/* overall calendar */
calendar {
    border-radius: 12px;
    font-size: 18px;
}
#header-box {
	color: #ff5555;
    font-size: 18px;
}

/* “Today” button */
#today-btn {
    background-color: #50fa7b;
    color: #282a36;
    border-radius: 20px;
    padding: 8px 16px;
    font-weight: bold;
    margin: 0 8px;
    font-size: 18px;
    box-shadow: none;
}
#today-btn:hover {
    background-color: #5aff88;
    box-shadow: 0 0 8px rgba(80,250,123,0.6);
}

"""

class DraculaCalendar(Gtk.Window):
    def __init__(self):
        super().__init__(title="Dracula Calendar")
        self.set_default_size(380, 420)
        self.set_resizable(False)
        self.set_decorated(False)
        
        # Apply CSS
        css = Gtk.CssProvider()
        css.load_from_data(DRACULA_CSS.encode())
        screen = Gdk.Screen.get_default()
        Gtk.StyleContext.add_provider_for_screen(
            screen,
            css,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        # Layout
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        main_box.set_border_width(12)
        self.add(main_box)

        # Header
        header = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        header.set_name("header-box")
        main_box.pack_start(header, False, False, 6)

        btn_prev = Gtk.Button(label="◀")
        btn_prev.connect("clicked", self.on_prev_month)
        btn_prev.set_can_focus(False)
        header.pack_start(btn_prev, False, False, 0)

        self.lbl_month = Gtk.Label()
        self.lbl_month.set_name("header-label")
        header.pack_start(self.lbl_month, True, True, 0)

        btn_next = Gtk.Button(label="▶")
        btn_next.connect("clicked", self.on_next_month)
        btn_next.set_can_focus(False)
        header.pack_start(btn_next, False, False, 0)

        # Today button
        today_btn = Gtk.Button(label="Today")
        today_btn.set_name("today-btn")
        today_btn.connect("clicked", self.on_today)
        main_box.pack_start(today_btn, False, False, 8)

        # Calendar widget
        self.calendar = Gtk.Calendar()
        self.calendar.set_display_options(
            Gtk.CalendarDisplayOptions.SHOW_HEADING |
            Gtk.CalendarDisplayOptions.SHOW_DAY_NAMES |
            Gtk.CalendarDisplayOptions.SHOW_WEEK_NUMBERS
        )
        self.calendar.connect("draw", lambda w, c: False)
        self.calendar.connect("day-selected", self.on_day_selected)
        main_box.pack_start(self.calendar, True, True, 0)

        # Statusbar
        self.status = Gtk.Statusbar()
        self.status.set_name("statusbar")
        main_box.pack_start(self.status, False, False, 0)

        # Initialize dates
        self.today = datetime.date.today()
        self.current_year = self.today.year
        self.current_month = self.today.month - 1
        self.update_calendar()
        self.mark_today()
        # Select current day initially
        self.calendar.select_day(self.today.day)

        # Make header draggable
        header.set_events(Gdk.EventMask.BUTTON_PRESS_MASK)
        header.connect("button-press-event", self.on_header_click)

        self.show_all()

    def on_header_click(self, _, evt):
        if evt.button == Gdk.BUTTON_PRIMARY:
            self.begin_move_drag(evt.button, int(evt.x_root), int(evt.y_root), evt.time)

    def update_calendar(self):
        self.calendar.select_month(self.current_month, self.current_year)
        title = datetime.date(
            self.current_year,
            self.current_month + 1,
            1
        ).strftime("%B %Y")
        self.lbl_month.set_text(title)
        self.mark_today()

    def mark_today(self):
        for d in range(1, 32):
            self.calendar.unmark_day(d)
        if (self.current_year == self.today.year and
            self.current_month == self.today.month - 1):
            self.calendar.mark_day(self.today.day)

    def on_prev_month(self, _):
        self.current_month -= 1
        if self.current_month < 0:
            self.current_month = 11
            self.current_year -= 1
        self.update_calendar()
        # Select first day when changing months
        self.calendar.select_day(1)

    def on_next_month(self, _):
        self.current_month += 1
        if self.current_month > 11:
            self.current_month = 0
            self.current_year += 1
        self.update_calendar()
        # Select first day when changing months
        self.calendar.select_day(1)

    def on_today(self, _):
        self.current_year = self.today.year
        self.current_month = self.today.month - 1
        self.update_calendar()
        # Properly select today
        self.calendar.select_day(self.today.day)
        # Update status bar
        dt = datetime.date(self.today.year, self.today.month, self.today.day)
        self.status.push(0, dt.strftime("Selected: %A, %B %d, %Y"))

    def on_day_selected(self, cal):
        y, m, d = cal.get_date()
        dt = datetime.date(y, m + 1, d)
        self.status.push(0, dt.strftime("Selected: %A, %B %d, %Y"))


if __name__ == "__main__":
    win = DraculaCalendar()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()
