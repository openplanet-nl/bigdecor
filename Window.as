namespace Window
{
	bool Visible = false;

	void Render()
	{
		int windowFlags = UI::GetDefaultWindowFlags() | UI::WindowFlags::NoResize | UI::WindowFlags::AlwaysAutoResize;
		if (UI::Begin("\\$cf9" + Icons::Map + "\\$z Create a new map##Create a new map", Visible, windowFlags)) {
			if (UI::IsWindowAppearing()) {
				Params::Initialize();
			}

			RenderContents();
		}
		UI::End();
	}

	void RenderContents()
	{
		// Require users to not be in a map
		if (GetApp().RootMap !is null) {
			UI::Text("Return to the main meun to create a new map.");
			return;
		}

		UI::SeparatorTextOpenplanet("\\$cf9" + Icons::Tree + "\\$z Environment");

		// Environment
		if (UI::BeginCombo("Environment", GetNameForEnvironment(Params::Environment))) {
			for (uint i = 0; i < Constants::Collections.Length; i++) {
				auto collection = cast<CGameCtnCollection>(Constants::Collections[i].Nod);
				string environment = collection.CollectionId_Text;
				if (!Setting_ShowStadium256 && environment == "Stadium256") {
					continue;
				}
				if (UI::Selectable(GetNameForEnvironment(environment), environment == Params::Environment)) {
					Params::SetEnvironment(environment);
				}
			}

			UI::EndCombo();
		}

		// Player model
		if (UI::BeginCombo("Player model", GetNameForPlayerModel(Params::PlayerModel))) {
			for (uint i = 0; i < Constants::PlayerModels.Length; i++) {
				string playerModel = Constants::PlayerModels[i];
				if (UI::Selectable(GetNameForPlayerModel(playerModel), playerModel == Params::PlayerModel)) {
					Params::PlayerModel = playerModel;
				}
			}
			UI::EndCombo();
		}

		// Decoration
		auto currentDeco = cast<CGameCtnDecoration>(Params::Decoration.Nod);
		if (UI::BeginCombo("Decoration", currentDeco.IdName)) {
			for (uint i = 0; i < Constants::Decorations.Length; i++) {
				auto pfid = Constants::Decorations[i];
				auto deco = cast<CGameCtnDecoration>(pfid.Nod);
				if (UI::Selectable(deco.IdName, currentDeco.IdName == deco.IdName)) {
					Params::SetDecoration(pfid);
				}
			}
			UI::EndCombo();
		}

		// User mod
		if (Constants::TextureMods.Length > 0) {
			if (UI::BeginCombo("Texture mod", Params::TextureMod == "" ? "\\$666(none)" : Params::TextureMod)) {
				if (UI::Selectable("\\$666(none)", Params::TextureMod == "")) {
					Params::TextureMod = "";
				}
				for (uint i = 0; i < Constants::TextureMods.Length; i++) {
					string mod = Constants::TextureMods[i];
					if (UI::Selectable(mod, mod == Params::TextureMod)) {
						Params::TextureMod = mod;
					}
				}
				UI::EndCombo();
			}
		}

		UI::SeparatorTextOpenplanet("\\$fc9" + Icons::Cube + "\\$z Properties");

		// Dimensions
		Params::DecoSize.x = UI::SliderInt("Size X", Params::DecoSize.x, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);
		Params::DecoSize.y = UI::SliderInt("Size Y (height)", Params::DecoSize.y, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);
		Params::DecoSize.z = UI::SliderInt("Size Z", Params::DecoSize.z, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);

		// Buttons
		if (UI::Button(Icons::PlusCircle + " Create map")) {
			Params::EditNewMap();
			Visible = false;
		}
		//todo: randomize button
	}

	string GetNameForEnvironment(const string &in environment)
	{
		if (environment == "Stadium") {
			return "\\$fd3" + Icons::Flag + "\\$z Stadium";
		} else if (environment == "GreenCoast") {
			return "\\$493" + Icons::Flag + "\\$z Green Coast";
		} else if (environment == "RedIsland") {
			return "\\$d21" + Icons::Flag + "\\$z Red Island";
		} else if (environment == "BlueBay") {
			return "\\$36d" + Icons::Flag + "\\$z Blue Bay";
		} else if (environment == "WhiteShore") {
			return "\\$5de" + Icons::Flag + "\\$z White Shore";
		}
		return environment;
	}

	string GetNameForPlayerModel(const string &in playerModel)
	{
		if (playerModel == "CarSport") {
			return "Stadium Car";
		} else if (playerModel == "CarSnow") {
			return "Snow Car";
		} else if (playerModel == "CarRally") {
			return "Rally Car";
		} else if (playerModel == "CarDesert") {
			return "Desert Car";
		} else if (playerModel == "CharacterPilot") {
			return "Pilot Character";
		}
		return playerModel;
	}
}

/*
class CreateUI
{
	bool m_visible = false;

	string m_stadiumType = "Base";
	array<string> m_stadiumTypes = {
		"Base",
		"NoStadium"
	};

	array<string> m_moods;

	string m_currentEnvironment;
	string m_currentCar;
	string m_currentMood = m_moods[1];
	string m_currentMod;

	array<string> m_environments;
	array<string> m_archetypes;
	array<string> m_mods;

	int m_decoSizeX;
	int m_decoSizeY;
	int m_decoSizeZ;
	int m_decoGroundY;
	int m_decoSizeStep = 16;

	CGameManiaTitle@ m_title;

	void Render()
	{
		if (!m_visible) {
			return;
		}

		auto app = GetApp();

		UI::Begin("Create a new map", m_visible, UI::WindowFlags::NoResize | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoCollapse);

		if (m_environments.Length <= 0 || m_archetypes.Length <= 0) {
			// Not in a pack
			UI::Text("Enter a title pack before trying to create a new map.");
		} else {

			// Mod
			

			UI::Text("Decoration properties");

			

			// Create
			if (UI::Button("Create")) {
				m_visible = false;
				EditNewMap();
			}
			UI::SameLine();
		}

		if (UI::Button("Close")) {
			m_visible = false;
		}

		UI::End();
	}

	void SetEnvironment(const string &in enviro)
	{
		if (m_currentEnvironment == enviro) {
			return;
		}

		m_currentEnvironment = enviro;
		if (m_currentEnvironment == "Stadium") {
			m_currentCar = "CarSport";
		}

		UpdateMoods();
		UpdateSizeSettings();
		SetMods();
	}

	void UpdateMoods()
	{
		//

		if (m_currentEnvironment == "Stadium") {
			m_moods = {
				"48x48Screen155Sunrise",
			};

		} else if (m_currentEnvironment == "BlueBay") {
			//

		} else if (m_currentEnvironment == "GreenCoast") {
			//
		}

		m_currentMood = m_moods[0];
	}

	void UpdateSizeSettings()
	{
		m_decoSizeY = 40;

		if (m_currentEnvironment == "Stadium") {
			m_decoSizeX = 48;
			m_decoGroundY = 8;
		}

		m_decoSizeZ = m_decoSizeX;
	}

	

	void Update()
	{
		if (!m_visible) {
			@m_title = null;
			return;
		}

		auto app = cast<CGameManiaPlanet>(GetApp());

		if (m_title !is app.LoadedManiaTitle) {
			@m_title = app.LoadedManiaTitle;
			UpdateInfo();
		}
	}

	void AddMods(CSystemFidsFolder@ folder)
	{
		if (folder is null) {
			return;
		}

		for (uint i = 0; i < folder.Leaves.Length; i++) {
			auto fidMod = folder.Leaves[i];
			m_mods.InsertLast(fidMod.FileName);
		}
	}

	void UpdateInfo()
	{
		m_environments.RemoveRange(0, m_environments.Length);
		m_archetypes.RemoveRange(0, m_archetypes.Length);

		for (uint i = 0; i < m_title.CollectionFids.Length; i++) {
			auto fid = cast<CSystemFidFile>(m_title.CollectionFids[i]);

			if (fid.ShortFileName == "Stadium" || fid.ShortFileName == "StadiumCE") {
				m_environments.InsertLast("Stadium");
				m_environments.InsertLast("BlueBay");
				m_environments.InsertLast("GreenCoast");
				m_environments.InsertLast("RedIsland");
				m_environments.InsertLast("WhiteShore");
				m_archetypes.InsertLast("CarSport");
				m_archetypes.InsertLast("CarSnow");
				m_archetypes.InsertLast("CarRally");
				m_archetypes.InsertLast("CarDesert");
				m_archetypes.InsertLast("CharacterPilot");
			}

			SetEnvironment(m_environments[0]);
		}
	}
}
*/
