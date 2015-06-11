namespace WebKitSeed {
    class Application : Gtk.Application {
        protected Gtk.ApplicationWindow window;
        protected WebKit.WebView web_view;

        public Application() {
            flags = ApplicationFlags.HANDLES_OPEN;
        }

        protected override void activate() {
            var context = WebKit.WebContext.get_default();
            context.set_process_model(WebKit.ProcessModel.SHARED_SECONDARY_PROCESS);
            context.initialize_web_extensions.connect((context) => {
                context.set_web_extensions_directory(".");
            });

            web_view = new WebKit.WebView();
            web_view.web_process_crashed.connect(() => {
                stdout.printf("Crashed\n");
                return false;
            });

            var settings = web_view.get_settings();
            settings.enable_developer_extras = true;

            window = new Gtk.ApplicationWindow(this);
            window.set_default_size(800, 600);
            window.add(web_view);

            window.show_all();
            window.present();
        }

        protected override void open(File[] files, string hint) {
            activate();

            web_view.load_uri(files[0].get_uri());
        }
    }
}

public static int main(string[] args) {
    var application = new WebKitSeed.Application();
    return application.run(args);
}