CGameCtnDecorationSize@ g_decorSize = null;
nat3 g_originalSize;

void OnTitleChange(CGameManiaTitle@ title)
{
	if (Window::Visible) {
		//Window::OnTitleChange(title);
	}
}

void OnEditorOpen()
{
}

void OnEditorClose()
{
	if (g_decorSize !is null) {
		g_decorSize.SizeX = g_originalSize.x;
		g_decorSize.SizeY = g_originalSize.y;
		g_decorSize.SizeZ = g_originalSize.z;
		@g_decorSize = null;
	}
}

void Main()
{
	//TODO: Remove before release; it's just for UI::IsWindowAppearing() to return true on plugin reload
	 yield();
	 Window::Visible = true;

	auto app = cast<CGameManiaPlanet>(GetApp());

	bool inMapEditor = false;
	CGameManiaTitle@ inTitle;

	while (true) {
		if (app.LoadedManiaTitle !is inTitle) {
			@inTitle = app.LoadedManiaTitle;
			OnTitleChange(inTitle);
		}
		yield();

		auto editor = cast<CGameCtnEditorFree>(app.Editor);
		if (!inMapEditor && editor !is null) {
			inMapEditor = true;
			OnEditorOpen();
		} else if (inMapEditor && editor is null) {
			inMapEditor = false;
			OnEditorClose();
		}
	}
}

void RenderMenu()
{
	bool canOpenAdvancedEditor = Permissions::OpenAdvancedMapEditor();
	if (UI::MenuItem("\\$cf9" + Icons::Map + "\\$z Create a new map", "", Window::Visible, canOpenAdvancedEditor)) {
		Window::Visible = !Window::Visible;
	}
}

void RenderInterface()
{
	if (Window::Visible) {
		Window::Render();
	}
}
