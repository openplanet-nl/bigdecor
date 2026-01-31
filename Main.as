CGameCtnDecorationSize@ g_decorSize = null;
nat3 g_originalSize;

void OnTitleChange()
{
	if (Window::Visible) {
		Params::Initialize();
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
	auto app = cast<CGameManiaPlanet>(GetApp());

	bool inMapEditor = false;
	CGameManiaTitle@ inTitle;

	while (true) {
		yield();

		if (app.LoadedManiaTitle !is inTitle) {
			@inTitle = app.LoadedManiaTitle;
			OnTitleChange();
		}

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
#if TMNEXT
	bool canOpenAdvancedEditor = Permissions::OpenAdvancedMapEditor();
#else
	bool canOpenAdvancedEditor = true;
#endif
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

#if TURBO
namespace Fids
{
	CMwNod@ Preload(CSystemFid@ fid)
	{
		auto fidFile = cast<CSystemFidFile>(fid);
		if (fidFile !is null) {
			return Fids::Preload(fidFile);
		}
		return null;
	}
}
#endif
