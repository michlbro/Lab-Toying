return {
    Atmosphere = {
        ClassName = "Atmosphere";
        Color = Color3.fromRGB(200,170,108);
        Decay = Color3.fromRGB(92,60,14);
        Density = 0.39500001072883606;
        Glare = 0;
        Haze = 0;
        Name = "Atmosphere";
        Offset = 0; 
    };
    Sky = {
        CelestialBodiesShown = true;
        ClassName = "Sky";
        MoonAngularSize = 11;
        MoonTextureId = "rbxasset://sky/moon.jpg";
        Name = "Sky";
        SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex";
        SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex";
        SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex";
        SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex";
        SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex";
        SkyboxUp = "rbxasset://textures/sky/sky512_up.tex";
        StarCount = 3000;
        SunAngularSize = 21;
        SunTextureId = "rbxasset://sky/sun.jpg"; 
    };
    Bloom = {
        ClassName = "BloomEffect";
        Enabled = true;
        Intensity = 1;
        Name = "Bloom";
        Size = 24;
        Threshold = 2; 
    };
    Blur = {
        ClassName = "BlurEffect";
        Enabled = true;
        Name = "Blur";
        Size = 24; 
    };
    ColorCorrection = {
        Brightness = 0;
        ClassName = "ColorCorrectionEffect";
        Contrast = 0;
        Enabled = true;
        Name = "ColorCorrection";
        Saturation = 0;
        TintColor = Color3.fromRGB(255,255,255);
    };
    DepthOfField = {
        ClassName = "DepthOfFieldEffect";
        Enabled = true;
        FarIntensity = 0.75;
        FocusDistance = 0.05000000074505806;
        InFocusRadius = 10;
        Name = "DepthOfField";
        NearIntensity = 0.75; 
    };
    SunRays = {
        ClassName = "SunRaysEffect";
        Enabled = true;
        Intensity = 0.25;
        Name = "SunRays";
        Spread = 1; 
    };
}