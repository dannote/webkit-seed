#include <glib.h>
#include <webkit2/webkit-web-extension.h>
#include <seed.h>

static void 
window_object_cleared_callback (WebKitScriptWorld *world, 
                                WebKitWebPage     *web_page, 
                                WebKitFrame       *frame, 
                                gpointer           user_data)
{
    SeedContext global_context;

    global_context = webkit_frame_get_javascript_context_for_script_world (frame, world);
    seed_init_with_context (NULL, NULL, global_context);
}

G_MODULE_EXPORT void
webkit_web_extension_initialize (WebKitWebExtension *extension)
{
    g_signal_connect (webkit_script_world_get_default (), 
                      "window-object-cleared", 
                      G_CALLBACK (window_object_cleared_callback), 
                      NULL);
}