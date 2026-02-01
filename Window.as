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
		auto app = cast<CTrackMania>(GetApp());

		// Require users to be in a title
		if (app.LoadedManiaTitle is null) {
			UI::Text("You must be in a titlepack to create a new map.");
			return;
		}

		// Require users to not be in a map
#if TURBO
		if (app.Challenge !is null) {
#else
		if (app.RootMap !is null) {
#endif
			UI::Text("Return to the main menu to create a new map.");
			return;
		}

		// Make sure we actually have some data
		if (GameData::Collections.Length == 0) {
			UI::Text("No collections available.");
			return;
		}

		UI::SeparatorTextOpenplanet("\\$cf9" + Icons::Tree + "\\$z Environment");

		// Collection
		UI::PushID("Collection");
		Params::Collection.RenderDebug();
		if (UI::BeginCombo("Collection", GetNameForCollection(Params::Collection))) {
			for (uint i = 0; i < GameData::Collections.Length; i++) {
				auto collectionFid = GameData::Collections[i];
				auto collection = cast<CGameCtnCollection>(collectionFid.Nod);
				if (!Setting_ShowStadium256 && GameData::GetCollectionId(collection) == "Stadium256") {
					continue;
				}
				if (UI::Selectable(GetNameForCollection(collection), collectionFid == Params::Collection)) {
					Params::SetCollection(collectionFid);
				}
			}

			UI::EndCombo();
		}
		UI::PopID();

		// Decoration
		UI::PushID("Decoration");
		Params::Decoration.RenderDebug();
		auto currentDeco = cast<CGameCtnDecoration>(Params::Decoration.Nod);
		if (UI::BeginCombo("Decoration", currentDeco.IdName)) {
			for (uint i = 0; i < GameData::Decorations.Length; i++) {
				auto pfid = GameData::Decorations[i];
				auto deco = cast<CGameCtnDecoration>(pfid.Nod);
				if (UI::Selectable(deco.IdName, currentDeco.IdName == deco.IdName)) {
					Params::SetDecoration(pfid);
				}
			}
			UI::EndCombo();
		}
		UI::PopID();

		// Player model
		if (UI::BeginCombo("Player model", GetNameForPlayerModel(Params::PlayerModel))) {
			for (uint i = 0; i < GameData::PlayerModels.Length; i++) {
				string playerModel = GameData::PlayerModels[i];
				if (UI::Selectable(GetNameForPlayerModel(playerModel), playerModel == Params::PlayerModel)) {
					Params::PlayerModel = playerModel;
				}
			}
			UI::EndCombo();
		}

		// User mod
		if (GameData::TextureMods.Length > 0) {
			if (UI::BeginCombo("Texture mod", Params::TextureMod == "" ? "\\$666(none)" : Params::TextureMod)) {
				if (UI::Selectable("\\$666(none)", Params::TextureMod == "")) {
					Params::TextureMod = "";
				}
				for (uint i = 0; i < GameData::TextureMods.Length; i++) {
					string mod = GameData::TextureMods[i];
					if (UI::Selectable(mod, mod == Params::TextureMod)) {
						Params::TextureMod = mod;
					}
				}
				UI::EndCombo();
			}
		}

		UI::SeparatorTextOpenplanet("\\$fc9" + Icons::Cube + "\\$z Properties");

		// Dimensions
		int sliderFlags = 0;
		if (!Setting_UnlimitDecoSize) {
			sliderFlags |= UI::SliderFlags::AlwaysClamp;
		}
		Params::DecoSize.x = UI::SliderInt("Size X", Params::DecoSize.x, 1, 255, "%d", sliderFlags);
		Params::DecoSize.y = UI::SliderInt("Size Y (height)", Params::DecoSize.y, 1, 255, "%d", sliderFlags);
		Params::DecoSize.z = UI::SliderInt("Size Z", Params::DecoSize.z, 1, 255, "%d", sliderFlags);
		UI::TextDisabled("Control-Click the sliders to type values.");

		// Buttons
		if (UI::Button(Icons::PlusCircle + " Create map")) {
			Params::EditNewMap();
			Visible = false;
		}
	}

	string GetNameForCollection(PreloadingFid@ collectionFid)
	{
		auto collection = cast<CGameCtnCollection>(collectionFid.Nod);
		return GetNameForCollection(collection);
	}

	string GetNameForCollection(CGameCtnCollection@ collection)
	{
		auto collectionId = GameData::GetCollectionId(collection);
#if TMNEXT
		if (collectionId == "Stadium") {
			return "\\$fd3" + Icons::Flag + "\\$z Stadium";
		} else if (collectionId == "GreenCoast") {
			return "\\$493" + Icons::Flag + "\\$z Green Coast";
		} else if (collectionId == "RedIsland") {
			return "\\$d21" + Icons::Flag + "\\$z Red Island";
		} else if (collectionId == "BlueBay") {
			return "\\$36d" + Icons::Flag + "\\$z Blue Bay";
		} else if (collectionId == "WhiteShore") {
			return "\\$5de" + Icons::Flag + "\\$z White Shore";
		}
#else
		if (collectionId == "Stadium") {
			return "\\$fd3" + Icons::Flag + "\\$z Stadium";
		} else if (collectionId == "Valley") {
			return "\\$493" + Icons::Flag + "\\$z Valley";
		} else if (collectionId == "Canyon") {
			return "\\$d21" + Icons::Flag + "\\$z Canyon";
		} else if (collectionId == "Lagoon") {
			return "\\$36d" + Icons::Flag + "\\$z Lagoon";
		}
#endif
		return collectionId;
	}

	string GetNameForPlayerModel(const string &in playerModel)
	{
#if TMNEXT
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
#else
		if (playerModel == "CanyonCar") {
			return "Canyon Car";
		} else if (playerModel == "StadiumCar") {
			return "Stadium Car";
		} else if (playerModel == "ValleyCar") {
			return "Valley Car";
		} else if (playerModel == "LagoonCar") {
			return "Lagoon Car";
		}
#endif
		return playerModel;
	}
}
