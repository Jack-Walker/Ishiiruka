/*===============================================================================*\
|########################        [Ishiiruka FX 0.6]        ######################||
|| Credist to:                                                                   ||
|| Asmodean (DolphinFX)                                                          ||
|| Matso (MATSODOF)                                                              ||
|| Gilcher Pascal aka Marty McFly (MATSODOF original port to MCFX)               ||
|| Daniel R�kos (Efficient Gaussian blur with linear sampling)                   ||
|| mudlord (FXAA)
|############################        By Tino          ############################|
\*===============================================================================*/
/*
[configuration]
[OptionBool]
GUIName = Ambient Only
OptionName = A_SSAO_ONLY
DefaultValue = False

[OptionBool]
GUIName = FXAA
OptionName = E_FXAA_ENABLED
DefaultValue = false

[OptionBool]
GUIName = SSAO
OptionName = A_SSAO_ENABLED
DefaultValue = True
ResolveAtCompilation = True

[OptionBool]
GUIName = SSGI
OptionName = A_SSAO_SSGI_ENABLED
DefaultValue = false
ResolveAtCompilation = True
DependentOption = A_SSAO_ENABLED

[OptionRangeInteger]
GUIName = SSAO Quality
OptionName = B_SSAO_SAMPLES
MinValue = 16
MaxValue = 64
StepAmount = 4
DefaultValue = 16
DependentOption = A_SSAO_ENABLED
ResolveAtCompilation = True

[OptionRangeFloat]
GUIName = Sample Range
OptionName = C_SAMPLE_RANGE
MinValue = 0.001
MaxValue = 0.04
StepAmount = 0.0001
DefaultValue = 0.0064
DependentOption = A_SSAO_ENABLED

[OptionRangeFloat]
GUIName = Filter Limit
OptionName = D_FILTER_LIMIT
MinValue = 0.001
MaxValue = 0.01
StepAmount = 0.0001
DefaultValue = 0.002
DependentOption = A_SSAO_ENABLED

[OptionRangeFloat]
GUIName = Max Depth
OptionName = E_MAX_DEPTH
MinValue = 0.0001
MaxValue = 0.02
StepAmount = 0.0001
DefaultValue = 0.015
DependentOption = A_SSAO_ENABLED

[OptionRangeFloat]
GUIName = Min Depth
OptionName = F_MIN_DEPTH
MinValue = 0.0
MaxValue = 0.02
StepAmount = 0.0001
DefaultValue = 0.0003
DependentOption = A_SSAO_ENABLED

[OptionBool]
GUIName = SSGI
OptionName = A_SSGI_ENABLED
DefaultValue = false
ResolveAtCompilation = True

[OptionRangeInteger]
GUIName = SSGI Samples
OptionName = iSSGISamples
MinValue = 5
MaxValue = 24
StepAmount = 1
DefaultValue = 10
DependentOption = A_SSGI_ENABLED
ResolveAtCompilation = True

[OptionRangeFloat]
GUIName = Sample Range
OptionName = fSSGISamplingRange
MinValue = 5.0
MaxValue = 80.0
StepAmount = 0.1
DefaultValue = 40.0
DependentOption = A_SSGI_ENABLED

[OptionRangeFloat]
GUIName = Ilumination Multiplier
OptionName = fSSGIIlluminationMult
MinValue = 1.0
MaxValue = 8.0
StepAmount = 0.1
DefaultValue = 4.0
DependentOption = A_SSGI_ENABLED

[OptionRangeFloat]
GUIName = Occlusion Multiplier
OptionName = fSSGIOcclusionMult
MinValue = 1.0
MaxValue = 10.0
StepAmount = 0.1
DefaultValue = 2.0
DependentOption = A_SSGI_ENABLED

[OptionRangeFloat]
GUIName = Model Thickness
OptionName = fSSGIModelThickness
MinValue = 0.5
MaxValue = 100.0
StepAmount = 0.1
DefaultValue = 40.0
DependentOption = A_SSGI_ENABLED

[OptionRangeFloat]
GUIName = Saturation
OptionName = fSSGISaturation
MinValue = 0.2
MaxValue = 2.0
StepAmount = 0.01
DefaultValue = 1.5
DependentOption = A_SSGI_ENABLED

[OptionRangeFloat]
GUIName = AO Sharpness
OptionName = AO_SHARPNESS
MinValue = 0.1
MaxValue = 5.0
StepAmount = 0.01
DefaultValue = 0.75
DependentOption = A_SSGI_ENABLED

[OptionBool]
GUIName = Ambient Only
OptionName = A_AO_ONLY
DefaultValue = False
DependentOption = A_SSGI_ENABLED

[OptionBool]
GUIName = Ilumination Only
OptionName = A_ILUMINATION_ONLY
DefaultValue = False
DependentOption = A_SSGI_ENABLED

[OptionBool]
GUIName = MATSO DOF
OptionName = MATSODOF
DefaultValue = True

[OptionBool]
GUIName = Use depth range focus
OptionName = DOF_A_FOCUSPOINT_RANGE
DefaultValue = false
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Focus Point
OptionName = DOF_B_FOCUSPOINT
MinValue = 0.0, 0.0
MaxValue = 1.0, 1.0
DefaultValue = 0.5, 0.5
StepAmount = 0.01, 0.01
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Near Blue Curve
OptionName = DOF_NEARBLURCURVE
MinValue = 0.4
MaxValue = 2.0
DefaultValue = 0.7
StepAmount = 0.01
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = FarBlue Curve
OptionName = DOF_FARBLURCURVE
MinValue = 0.4
MaxValue = 2.0
DefaultValue = 1.5
StepAmount = 0.01
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Blur Radius
OptionName = DOF_BLURRADIUS
MinValue = 5.0
MaxValue = 50.0
DefaultValue = 5.0
StepAmount = 1.0
DependentOption = MATSODOF

[OptionRangeInteger]
GUIName = Vignette
OptionName = DOF_VIGNETTE
MinValue = 0
MaxValue = 1000
DefaultValue = 400
StepAmount = 10
DependentOption = MATSODOF

[OptionBool]
GUIName = CROMA Enable
OptionName = bMatsoDOFChromaEnable
DefaultValue = True
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Chroma Pow
OptionName = fMatsoDOFChromaPow
MinValue = 0.2
MaxValue = 3.0
DefaultValue = 1.4
StepAmount = 0.01
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Bokeh Curve
OptionName = fMatsoDOFBokehCurve
MinValue = 0.5
MaxValue = 20.0
DefaultValue = 8.0
StepAmount = 0.01
DependentOption = MATSODOF

[OptionRangeFloat]
GUIName = Bokeh Light
OptionName = fMatsoDOFBokehLight
MinValue = 0.0
MaxValue = 2.0
DefaultValue = 0.012
StepAmount = 0.001
DependentOption = MATSODOF

[OptionRangeInteger]
GUIName = Bokeh Quality
OptionName = iMatsoDOFBokehQuality
MinValue = 1
MaxValue = 10
DefaultValue = 4
StepAmount = 1
DependentOption = MATSODOF
ResolveAtCompilation = True

[OptionRangeInteger]
GUIName = Bokeh Angle
OptionName = fMatsoDOFBokehAngle
MinValue = 0
MaxValue = 360
DefaultValue = 0
StepAmount = 1
DependentOption = MATSODOF
[OptionBool]
GUIName = Pixel Vibrance
OptionName = H_PIXEL_VIBRANCE
DefaultValue = false

[OptionRangeFloat]
GUIName = Vibrance
OptionName = A_VIBRANCE
MinValue = -0.50
MaxValue = 1.00
StepAmount = 0.01
DefaultValue = 0.15
DependentOption = H_PIXEL_VIBRANCE

[OptionRangeFloat]
GUIName = RedVibrance
OptionName = B_R_VIBRANCE
MinValue = -1.00
MaxValue = 4.00
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = H_PIXEL_VIBRANCE

[OptionRangeFloat]
GUIName = GreenVibrance
OptionName = C_G_VIBRANCE
MinValue = -1.00
MaxValue = 4.00
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = H_PIXEL_VIBRANCE

[OptionRangeFloat]
GUIName = BlueVibrance
OptionName = D_B_VIBRANCE
MinValue = -1.00
MaxValue = 4.00
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = H_PIXEL_VIBRANCE

[OptionBool]
GUIName = Scene Tonemapping
OptionName = C_TONEMAP_PASS
DefaultValue = true

[OptionRangeInteger]
GUIName = TonemapType
OptionName = A_TONEMAP_TYPE
MinValue = 0
MaxValue = 3
StepAmount = 1
DefaultValue = 1
DependentOption = C_TONEMAP_PASS

[OptionRangeInteger]
GUIName = FilmOperator
OptionName = A_TONEMAP_FILM
MinValue = 0
MaxValue = 1
StepAmount = 1
DefaultValue = 1
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = ToneAmount
OptionName = B_TONE_AMOUNT
MinValue = 0.05
MaxValue = 2.00
StepAmount = 0.01
DefaultValue = 0.30
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = FilmStrength
OptionName = B_TONE_FAMOUNT
MinValue = 0.00
MaxValue = 1.00
StepAmount = 0.01
DefaultValue = 0.25
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = BlackLevels
OptionName = C_BLACK_LEVELS
MinValue = 0.00
MaxValue = 1.00
StepAmount = 0.01
DefaultValue = 0.06
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = Exposure
OptionName = D_EXPOSURE
MinValue = 0.50
MaxValue = 1.50
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = Luminance
OptionName = E_LUMINANCE
MinValue = 0.50
MaxValue = 1.50
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = C_TONEMAP_PASS

[OptionRangeFloat]
GUIName = WhitePoint
OptionName = F_WHITEPOINT
MinValue = 0.50
MaxValue = 1.50
StepAmount = 0.01
DefaultValue = 1.00
DependentOption = C_TONEMAP_PASS

[OptionBool]
GUIName = Texture Sharpen
OptionName = G_TEXTURE_SHARPEN
DefaultValue = false

[OptionRangeFloat]
GUIName = SharpenStrength
OptionName = A_SHARPEN_STRENGTH
MinValue = 0.00
MaxValue = 2.00
StepAmount = 0.01
DefaultValue = 0.75
DependentOption = G_TEXTURE_SHARPEN

[OptionRangeFloat]
GUIName = SharpenClamp
OptionName = B_SHARPEN_CLAMP
MinValue = 0.005
MaxValue = 0.250
StepAmount = 0.001
DefaultValue = 0.012
DependentOption = G_TEXTURE_SHARPEN

[OptionRangeFloat]
GUIName = SharpenBias
OptionName = C_SHARPEN_BIAS
MinValue = 1.00
MaxValue = 4.00
StepAmount = 0.05
DefaultValue = 1.00
DependentOption = G_TEXTURE_SHARPEN

[OptionRangeInteger]
GUIName = ShowEdgeMask
OptionName = D_SEDGE_DETECTION
MinValue = 0
MaxValue = 1
StepAmount = 1
DefaultValue = 0
DependentOption = G_TEXTURE_SHARPEN

[OptionBool]
GUIName = Bloom
OptionName = D_BLOOM
DefaultValue = true

[OptionRangeFloat]
GUIName = Bloom Width
OptionName = A_BLOOMWIDTH
MinValue = 1.0
MaxValue = 1.5
StepAmount = 0.01
DefaultValue = 3.0
DependentOption = D_BLOOM

[OptionRangeFloat]
GUIName = Bloom Power
OptionName = B_BLOOMPOWER
MinValue = 1.0
MaxValue = 8.0
StepAmount = 0.1
DefaultValue = 3.0
DependentOption = D_BLOOM

[OptionRangeFloat]
GUIName = Bloom Intensity
OptionName = B_BLOOMINTENSITY
MinValue = 0.5
MaxValue = 1.0
StepAmount = 0.01
DefaultValue = 1.0
DependentOption = D_BLOOM

[OptionBool]
GUIName = Barrel Distortion
OptionName = E_BARREL
DefaultValue = false

[OptionRangeFloat]
GUIName = Lens Center Offset
OptionName = u_lensCenterOffset
MinValue = -1.0, -1.0
MaxValue = 1.0, 1.0
StepAmount = 0.001, 0.001
DefaultValue = 0.0, 0.0
DependentOption = E_BARREL

[OptionRangeFloat]
GUIName = Distortion
OptionName = u_distortion
MinValue = 0.0, 0.0, 0.0, 0.0
MaxValue = 1.0, 1.0, 1.0, 1.0
StepAmount = 0.001, 0.001, 0.001, 0.001
DefaultValue = 1.0, 0.22, 0.0, 0.24
DependentOption = E_BARREL

[Stage]
EntryPoint = AmbientOcclusion
DependentOption = A_SSAO_ENABLED,A_SSGI_ENABLED
[Stage]
EntryPoint = AOBlur
DependentOption = A_SSAO_ENABLED,A_SSGI_ENABLED
[Stage]
EntryPoint = Merger
[Stage]
EntryPoint = ReduceSize
DependentOption = D_BLOOM
OutputScale = 0.25
[Stage]
EntryPoint = BloomH
DependentOption = D_BLOOM
OutputScale = 0.25
[Stage]
EntryPoint = BloomV
DependentOption = D_BLOOM
OutputScale = 0.25
[Stage]
EntryPoint = BloomH
DependentOption = D_BLOOM
OutputScale = 0.25
[Stage]
EntryPoint = BloomV
DependentOption = D_BLOOM
OutputScale = 0.25
[Stage]
EntryPoint = BloomMerger
DependentOption = D_BLOOM
Inputs = 7, 2
[Stage]
EntryPoint = PS_DOF_MatsoDOF1
DependentOption = MATSODOF
[Stage]
EntryPoint = PS_DOF_MatsoDOF2
DependentOption = MATSODOF
[Stage]
EntryPoint = PS_DOF_MatsoDOF3
DependentOption = MATSODOF
[Stage]
EntryPoint = PS_DOF_MatsoDOF4
DependentOption = MATSODOF
[Stage]
EntryPoint = Barrel_distortion
DependentOption = E_BARREL
[Stage]
EntryPoint = FXAAPS
DependentOption = E_FXAA_ENABLED
[/configuration]
*/
float3 GetNormalFromDepth(float fDepth)
{
	float depth1 = SampleDepthOffset(int2(0, 1));
	float depth2 = SampleDepthOffset(int2(1, 0));
	float2 invres = GetInvResolution();
	float3 p1 = float3(0, invres.y, depth1 - fDepth);
	float3 p2 = float3(invres.x, 0, depth2 - fDepth);

	float3 normal = cross(p1, p2);
	normal.z = -normal.z;

	return normalize(normal);
}
#define FILTER_RADIUS 4

float4 Bilateral(int2 offsetmask, float depth)
{
	float limit = GetOption(D_FILTER_LIMIT);
	float count = 1.0;
	float4 value = SamplePrev();

	for (int i = 1; i < (FILTER_RADIUS + 1); i++)
	{
		int2 offset = offsetmask * i;
		float Weight = min(sign(limit - abs(SampleDepthOffset(offset) - depth)) + 1.0, 1.0);
		value += SamplePrevOffset(offset) * Weight;
		count += Weight;
		offset = -offset;
		Weight = min(sign(limit - abs(SampleDepthOffset(offset) - depth)) + 1.0, 1.0);
		value += SamplePrevOffset(offset) * Weight;
		count += Weight;
	}
	return value / count;
}

float3 GetEyePosition(float2 uv, float eye_z, float2 InvFocalLen) {
	uv = (uv * float2(2.0, -2.0) - float2(1.0, -1.0));
	float3 pos = float3(uv * InvFocalLen * eye_z, eye_z);
	return pos;
}

float2 GetRandom2_10(float2 uv) {
	float noiseX = (frac(sin(dot(uv, float2(12.9898, 78.233) * 2.0)) * 43758.5453));
	float noiseY = sqrt(1 - noiseX * noiseX);
	return float2(noiseX, noiseY);
}

float4 PS_AO_Blur(float2 axis)
{
	float gaussweight[7] = { 0.111220, 0.107798, 0.098151, 0.083953, 0.067458, 0.050920, 0.036108 };
	float4 sum = float4(0.0, 0.0, 0.0, 0.0);
	float totalweight = 0.0;
	float4 base = SamplePrev();
	float4 temp = sum;

	float centerdepth = SampleDepth();
	float2 texcoord = GetCoordinates();
	axis *= GetInvResolution();
	for (int r = -6; r <= 6; ++r)
	{
		float2 coord = texcoord.xy + axis * r;
		temp = SamplePrevLocation(coord);
		float tempdepth = SampleDepthLocation(coord);
		float weight = 0.3 + gaussweight[abs(r)];
		weight *= max(0.0, 1.0 - (1000.0 * GetOption(AO_SHARPNESS)) * abs(tempdepth - centerdepth));
		sum += temp * weight;
		totalweight += weight;
	}

	return sum / (totalweight + 0.0001);
}

void AOBlur()
{
#if A_SSAO_ENABLED != 0
		SetOutput(Bilateral(int2(1, 0), SampleDepth()));
#elif A_SSGI_ENABLED != 0
	float2 axis = float2(0, 1);
	SetOutput(PS_AO_Blur(axis));
#endif
}

float4 SSAO()
{
	float3 PoissonDisc[] = {
		float3(-0.367046f, 0.692618f, 0.0136723f),
		float3(0.262978f, -0.363506f, 0.231819f),
		float3(-0.734306f, -0.451643f, 0.264779f),
		float3(-0.532456f, 0.683096f, 0.552049f),
		float3(0.672536f, 0.283731f, 0.0694296f),
		float3(-0.194678f, 0.548204f, 0.56859f),
		float3(-0.87347f, -0.572741f, 0.923795f),
		float3(0.548936f, -0.717277f, 0.0201727f),
		float3(0.48381f, 0.691397f, 0.699088f),
		float3(-0.592273f, 0.41966f, 0.413953f),
		float3(-0.448042f, -0.957396f, 0.123234f),
		float3(-0.618458f, 0.112949f, 0.412946f),
		float3(-0.412763f, 0.122227f, 0.732078f),
		float3(0.816462f, -0.900815f, 0.741417f),
		float3(-0.0381787f, 0.511521f, 0.799768f),
		float3(-0.688284f, 0.310099f, 0.472732f),
		float3(-0.368023f, 0.720572f, 0.544206f),
		float3(-0.379192f, -0.55504f, 0.035371f),
		float3(0.15482f, 0.0353709f, 0.543779f),
		float3(0.153417f, -0.521409f, 0.943724f),
		float3(-0.168371f, -0.702933f, 0.145665f),
		float3(-0.673391f, -0.925657f, 0.61391f),
		float3(-0.479171f, -0.131993f, 0.659932f),
		float3(0.0549638f, -0.470809f, 0.420759f),
		float3(0.899594f, 0.955077f, 0.54857f),
		float3(-0.230689f, 0.660573f, 0.548112f),
		float3(0.0421461f, -0.19895f, 0.121799f),
		float3(-0.229774f, -0.30137f, 0.507492f),
		float3(-0.983642f, 0.468551f, 0.0393994f),
		float3(-0.00857568f, 0.440657f, 0.337046f),
		float3(0.730461f, -0.283914f, 0.789941f),
		float3(0.271828f, -0.226356f, 0.317026f),
		float3(-0.178869f, -0.946837f, 0.073336f),
		float3(0.389813f, -0.110508f, 0.0549944f),
		float3(0.0242622f, 0.893613f, 0.26957f),
		float3(-0.857601f, 0.0219429f, 0.45146f),
		float3(-0.15659f, 0.550401f, 3.05185e-005f),
		float3(0.0555742f, -0.354656f, 0.573412f),
		float3(-0.267373f, 0.117466f, 0.488571f),
		float3(-0.533799f, -0.431928f, 0.226661f),
		float3(0.49852f, -0.750908f, 0.412427f),
		float3(-0.300882f, 0.366314f, 0.558245f),
		float3(-0.176f, 0.511521f, 0.722465f),
		float3(-0.0514847f, -0.703543f, 0.180273f),
		float3(-0.429914f, 0.0774255f, 0.161534f),
		float3(-0.416791f, -0.788385f, 0.328135f),
		float3(0.127293f, -0.115146f, 0.958586f),
		float3(-0.34959f, -0.278481f, 0.168706f),
		float3(-0.645192f, 0.168798f, 0.577105f),
		float3(-0.190771f, -0.622669f, 0.257851f),
		float3(0.718986f, -0.275369f, 0.602039f),
		float3(-0.444258f, -0.872982f, 0.0275582f),
		float3(0.793512f, 0.0511185f, 0.33964f),
		float3(-0.143651f, 0.155614f, 0.368877f),
		float3(-0.777093f, 0.246864f, 0.290628f),
		float3(0.202979f, -0.61742f, 0.233802f),
		float3(0.198523f, 0.425153f, 0.409162f),
		float3(-0.629688f, 0.597461f, 0.120212f),
		float3(0.0448316f, -0.689566f, 0.0241707f),
		float3(-0.190039f, 0.426496f, 0.254463f),
		float3(-0.255776f, 0.722831f, 0.527451f),
		float3(-0.821528f, 0.303751f, 0.140172f),
		float3(0.696646f, 0.168981f, 0.404492f),
		float3(-0.240211f, -0.109653f, 0.463301f),
	};

	const float2 rndNorm[] =
	{
		float2(0.505277f, 0.862957f),
		float2(-0.554562f, 0.832142f),
		float2(0.663051f, 0.748574f),
		float2(-0.584629f, -0.811301f),
		float2(-0.702343f, 0.711838f),
		float2(0.843108f, -0.537744f),
		float2(0.85856f, 0.512713f),
		float2(0.506966f, -0.861966f),
		float2(0.614758f, -0.788716f),
		float2(0.993426f, -0.114472f),
		float2(-0.676375f, 0.736558f),
		float2(-0.891668f, 0.45269f),
		float2(0.226367f, 0.974042f),
		float2(-0.853615f, -0.520904f),
		float2(0.467359f, 0.884067f),
		float2(-0.997111f, 0.0759529f),
	};

	float2 coords = GetCoordinates();
	float fCurrDepth = SampleDepth();
	float4 Occlusion = float4(0.0, 0.0, 0.0, 1.0);
	if (fCurrDepth < 0.9999)
	{
		float sample_range = GetOption(C_SAMPLE_RANGE) * fCurrDepth;
		float3 vViewNormal = GetNormalFromDepth(fCurrDepth);
		uint2 fragcoord = uint2(GetFragmentCoord()) & 3;
		uint rndidx = fragcoord.y * 4 + fragcoord.x;
		float3 vRandom = float3(rndNorm[rndidx], 0);
		float fAO = 0;
		const int NUMSAMPLES = B_SSAO_SAMPLES;
		for (int s = 0; s < NUMSAMPLES; s++)
		{
			float3 offset = PoissonDisc[s];
			float3 vReflRay = reflect(offset, vRandom);

			float fFlip = sign(dot(vViewNormal, vReflRay));
			vReflRay *= fFlip;
			
			float sD = fCurrDepth - (vReflRay.z * sample_range);
			float2 location = saturate(coords + (sample_range * vReflRay.xy / fCurrDepth));
			float fSampleDepth = SampleDepthLocation(location);
			float fDepthDelta = saturate(sD - fSampleDepth);

			fDepthDelta *= 1 - smoothstep(0, GetOption(E_MAX_DEPTH), fDepthDelta);

			if (fDepthDelta > GetOption(F_MIN_DEPTH) && fDepthDelta < GetOption(E_MAX_DEPTH))
			{
#if A_SSAO_SSGI_ENABLED == 1
				Occlusion.rgb += SampleLocation(location).rgb;
#endif
				fAO += pow(1 - fDepthDelta, 2.5);
			}
		}
		Occlusion.a = 1.0 - (fAO / float(NUMSAMPLES));
#if A_SSAO_SSGI_ENABLED == 1
		Occlusion.rgb = Occlusion.rgb / float(NUMSAMPLES);
#endif
		Occlusion = saturate(Occlusion);
	}
	return Occlusion;
}

float4 PS_AO_SSGI()
{
	float depth = SampleDepth();
	float2 texcoord = GetCoordinates();
	float4 Occlusion1R = float4(0.0, 0.0, 0.0, 1.0);
	if (depth < 0.9999)
	{
		float2 sample_offset[24] =
		{
			float2(-0.1376476f,  0.2842022f),float2(-0.626618f ,  0.4594115f),
			float2(-0.8903138f, -0.05865424f),float2(0.2871419f,  0.8511679f),
			float2(-0.1525251f, -0.3870117f),float2(0.6978705f, -0.2176773f),
			float2(0.7343006f,  0.3774331f),float2(0.1408805f, -0.88915f),
			float2(-0.6642616f, -0.543601f),float2(-0.324815f, -0.093939f),
			float2(-0.1208579f , 0.9152063f),float2(-0.4528152f, -0.9659424f),
			float2(-0.6059740f,  0.7719080f),float2(-0.6886246f, -0.5380305f),
			float2(0.5380307f, -0.2176773f),float2(0.7343006f,  0.9999345f),
			float2(-0.9976073f, -0.7969264f),float2(-0.5775355f,  0.2842022f),
			float2(-0.626618f ,  0.9115176f),float2(-0.29818942f, -0.0865424f),
			float2(0.9161239f,  0.8511679f),float2(-0.1525251f, -0.07103951f),
			float2(0.7022788f, -0.823825f),float2(0.60250657f,  0.64525909f)
		};

		float sample_radius[24] =
		{
			0.5162497,0.2443335,
			0.1014819,0.1574599,
			0.6538922,0.5637644,
			0.6347278,0.2467654,
			0.5642318,0.0035689,
			0.6384532,0.3956547,
			0.7049623,0.3482861,
			0.7484038,0.2304858,
			0.0043161,0.5423726,
			0.5025704,0.4066662,
			0.2654198,0.8865175,
			0.9505567,0.9936577
		};

		float2 InvFocalLen = float2(1.0, tan(0.5235987756));
		float aspect = GetInvResolution().y * GetResolution().x;
		InvFocalLen.x = InvFocalLen.y * aspect;
		float3 pos = GetEyePosition(texcoord.xy, depth, InvFocalLen);
		float3 dx = ddx(pos);
		float3 dy = ddy(pos);
		float3 norm = normalize(cross(dx, dy));
		norm.y *= -1;

		float4 gi = float4(0.0, 0.0, 0.0, 0.0);
		float is = 0.0, as = 0.0;

		float rangeZ = 5000.0;




		float2 rand_vec = GetRandom2_10(texcoord.xy);
		float2 rand_vec2 = GetRandom2_10(-texcoord.xy);
		float2 sample_vec_divisor = InvFocalLen * depth / (GetOption(fSSGISamplingRange) * GetInvResolution().xy);
		float2 sample_center = texcoord.xy + norm.xy / sample_vec_divisor * float2(1, aspect);
		float ii_sample_center_depth = depth * rangeZ + norm.z * GetOption(fSSGISamplingRange) * 30;
		float ao_sample_center_depth = depth * rangeZ + norm.z * GetOption(fSSGISamplingRange) * 5;



		for (int i = 0; i < iSSGISamples; i++)
		{
			float2 sample_vec = reflect(sample_offset[i], rand_vec) / sample_vec_divisor;
			float2 sample_coords = sample_center + sample_vec *  float2(1, aspect);
			float  sample_depth = rangeZ * SampleDepthLocation(sample_coords);

			float ii_curr_sample_radius = sample_radius[i] * GetOption(fSSGISamplingRange) * 30;
			float ao_curr_sample_radius = sample_radius[i] * GetOption(fSSGISamplingRange) * 5;

			gi.a += clamp(0, ao_sample_center_depth + ao_curr_sample_radius - sample_depth, 2 * ao_curr_sample_radius);
			gi.a -= clamp(0, ao_sample_center_depth + ao_curr_sample_radius - sample_depth - GetOption(fSSGIModelThickness), 2 * ao_curr_sample_radius);

			if ((sample_depth < ii_sample_center_depth + ii_curr_sample_radius) &&
				(sample_depth > ii_sample_center_depth - ii_curr_sample_radius)) {
				gi.rgb += SampleLocation(sample_coords).rgb;
			}

			is += 1.0f;
			as += 2.0f * ao_curr_sample_radius;
		}

		gi.rgb /= is * 5.0f;
		gi.a /= as;

		gi.rgb = 0.0 + gi.rgb * GetOption(fSSGIIlluminationMult);
		gi.a = 1.0 - gi.a   * GetOption(fSSGIOcclusionMult);

		gi.rgb = lerp(dot(gi.rgb, float3(0.333, 0.333, 0.333)) * float3(1.0, 1.0, 1.0), gi.rgb, GetOption(fSSGISaturation));

		Occlusion1R = gi;
	}
	return Occlusion1R;
}

void AmbientOcclusion()
{
	float4 value = float4(1.0, 1.0, 1.0, 1.0);
#if A_SSAO_ENABLED != 0
	value = SSAO();
#elif A_SSGI_ENABLED != 0
	value = PS_AO_SSGI();
#endif 
	SetOutput(value);
}

#define PI 		3.1415972
#define PIOVER180 	0.017453292


float4 GetMatsoDOFCA(float2 tex, float CoC)
{
	float3 ChromaPOW = float3(1, 1, 1) * GetOption(fMatsoDOFChromaPow) * CoC;
	float3 chroma = pow(float3(0.5, 1.0, 1.5), ChromaPOW) * 0.5;
	tex = (2.0 * tex - 1.0);
	float2 tr = (tex * chroma.r) + 0.5;
	float2 tg = (tex * chroma.g) + 0.5;
	float2 tb = (tex * chroma.b) + 0.5;

	float3 color = float3(SamplePrevLocation(tr).r, SamplePrevLocation(tg).g, SamplePrevLocation(tb).b) * (1.0 - CoC);

	return float4(color, 1.0);
}

float4 GetMatsoDOFBlur(int axis, float2 coord)
{
	float4 tcol = SamplePrevLocation(coord);
	float scenedepth = SampleDepth();
	float scenefocus = 0.0f;
	if (OptionEnabled(DOF_A_FOCUSPOINT_RANGE))
	{
		scenefocus = GetOption(DOF_B_FOCUSPOINT).x;
	}
	else
	{
		scenefocus = SampleDepthLocation(GetOption(DOF_B_FOCUSPOINT));
	}
	float depthdiff = abs(scenedepth - scenefocus);
	if (OptionEnabled(DOF_A_FOCUSPOINT_RANGE))
	{
		if (abs(depthdiff) < GetOption(DOF_B_FOCUSPOINT).y)
		{
			depthdiff *= 0.5f * depthdiff * depthdiff;
		}
	}
	depthdiff = (scenedepth < scenefocus) ? pow(depthdiff, GetOption(DOF_NEARBLURCURVE))*(1.0f + pow(abs(0.5f - coord.x)*depthdiff + 0.1f, 2.0)*GetOption(DOF_VIGNETTE)) : depthdiff;
	depthdiff = (scenedepth > scenefocus) ? pow(depthdiff, GetOption(DOF_FARBLURCURVE)) : depthdiff;

	float2 discRadius = depthdiff * GetOption(DOF_BLURRADIUS)*GetInvResolution()*0.5 / float(iMatsoDOFBokehQuality);

	int passnumber = 1;

	float sf = 0;

	float2 tdirs[4] = { float2(-0.306, 0.739), float2(0.306, 0.739), float2(-0.739, 0.306), float2(-0.739, -0.306) };
	float wValue = (1.0 + pow(length(tcol.rgb) + 0.1, GetOption(fMatsoDOFBokehCurve))) * (1.0 - GetOption(fMatsoDOFBokehLight));	// special recipe from papa Matso ;)

	for (int i = -iMatsoDOFBokehQuality; i < iMatsoDOFBokehQuality; i++)
	{
		float2 taxis = tdirs[axis];

		taxis.x = cos(GetOption(fMatsoDOFBokehAngle)*PIOVER180)*taxis.x - sin(GetOption(fMatsoDOFBokehAngle)*PIOVER180)*taxis.y;
		taxis.y = sin(GetOption(fMatsoDOFBokehAngle)*PIOVER180)*taxis.x + cos(GetOption(fMatsoDOFBokehAngle)*PIOVER180)*taxis.y;

		float2 tdir = float(i) * taxis * discRadius;
		float2 tcoord = coord.xy + tdir.xy;
		float4 ct;
		if (OptionEnabled(bMatsoDOFChromaEnable))
		{
			ct = GetMatsoDOFCA(tcoord.xy, discRadius.x);
		}
		else
		{
			ct = SamplePrevLocation(tcoord.xy);
		}
		float w = 0.0;
		float b = dot(ct.rgb, float3(0.333, 0.333, 0.333)) + length(ct.rgb) + 0.1;
		w = pow(b, GetOption(fMatsoDOFBokehCurve)) + abs(float(i));
		tcol += ct * w;
		wValue += w;
	}

	tcol /= wValue;

	return float4(tcol.xyz, 1.0);
}

void PS_DOF_MatsoDOF1()
{
	SetOutput(GetMatsoDOFBlur(2, GetCoordinates()));
}

void PS_DOF_MatsoDOF2()
{
	SetOutput(GetMatsoDOFBlur(3, GetCoordinates()));
}

void PS_DOF_MatsoDOF3()
{
	SetOutput(GetMatsoDOFBlur(0, GetCoordinates()));
}

void PS_DOF_MatsoDOF4()
{
	SetOutput(GetMatsoDOFBlur(1, GetCoordinates()));
}


/*------------------------------------------------------------------------------
[GLOBALS|FUNCTIONS]
------------------------------------------------------------------------------*/

#define Epsilon (1e-10)
#define lumCoeff float3(0.299f, 0.587f, 0.114f)

//Average relative luminance
float AvgLuminance(float3 color)
{
	return sqrt(dot(color * color, lumCoeff));
}

//Conversion matrices
float3 RGBtoXYZ(float3 rgb)
{
	const float3x3 m = float3x3(
		0.4124564, 0.3575761, 0.1804375,
		0.2126729, 0.7151522, 0.0721750,
		0.0193339, 0.1191920, 0.9503041);

	return mul(rgb, m);
}

float3 XYZtoRGB(float3 xyz)
{
	const float3x3 m = float3x3(
		3.2404542, -1.5371385, -0.4985314,
		-0.9692660, 1.8760108, 0.0415560,
		0.0556434, -0.2040259, 1.0572252);

	return mul(xyz, m);
}

float3 RGBtoYUV(float3 RGB)
{
	const float3x3 m = float3x3(
		0.2126, 0.7152, 0.0722,
		-0.09991, -0.33609, 0.436,
		0.615, -0.55861, -0.05639);

	return mul(RGB, m);
}

float3 YUVtoRGB(float3 YUV)
{
	const float3x3 m = float3x3(
		1.000, 0.000, 1.28033,
		1.000, -0.21482, -0.38059,
		1.000, 2.12798, 0.000);

	return mul(YUV, m);
}

//Converting XYZ to Yxy
float3 XYZtoYxy(float3 xyz)
{
	float3 Yxy;
	float w = 1.0 / (xyz.r + xyz.g + xyz.b);

	Yxy.r = xyz.g;
	Yxy.g = xyz.r * w;
	Yxy.b = xyz.g * w;

	return Yxy;
}

//Converting Yxy to XYZ
float3 YxytoXYZ(float3 Yxy)
{
	float3 xyz;
	float w = 1.0 / Yxy.b;
	xyz.g = Yxy.r;
	xyz.r = Yxy.r * Yxy.g * w;
	xyz.b = Yxy.r * (1.0 - Yxy.g - Yxy.b) * w;
	return xyz;
}

/*------------------------------------------------------------------------------
[SCENE TONE MAPPING CODE SECTION]
------------------------------------------------------------------------------*/

float3 EncodeGamma(float3 color, float gamma)
{
	color = saturate(color);
	color.r = (color.r <= 0.0404482362771082) ?
		color.r / 12.92 : pow((color.r + 0.055) / 1.055, gamma);
	color.g = (color.g <= 0.0404482362771082) ?
		color.g / 12.92 : pow((color.g + 0.055) / 1.055, gamma);
	color.b = (color.b <= 0.0404482362771082) ?
		color.b / 12.92 : pow((color.b + 0.055) / 1.055, gamma);

	return color;
}

float3 FilmicCurve(float3 color)
{
	float3 T = color;
	float tnamn = GetOption(B_TONE_AMOUNT);

	float A = 0.100;
	float B = 0.300;
	float C = 0.100;
	float D = tnamn;
	float E = 0.020;
	float F = 0.300;
	float W = 1.012;

	T.r = ((T.r*(A*T.r + C*B) + D*E) / (T.r*(A*T.r + B) + D*F)) - E / F;
	T.g = ((T.g*(A*T.g + C*B) + D*E) / (T.g*(A*T.g + B) + D*F)) - E / F;
	T.b = ((T.b*(A*T.b + C*B) + D*E) / (T.b*(A*T.b + B) + D*F)) - E / F;

	float denom = ((W*(A*W + C*B) + D*E) / (W*(A*W + B) + D*F)) - E / F;
	float3 white = float3(denom, denom, denom);

	T = T / white;
	color = saturate(T);

	return color;
}

float3 FilmicTonemap(float3 color)
{
	float3 tone = color;

	float3 black = float3(0.0, 0.0, 0.0);
	tone = max(black, tone);

	tone.r = (tone.r * (6.2 * tone.r + 0.5)) / (tone.r * (6.2 * tone.r + 1.66) + 0.066);
	tone.g = (tone.g * (6.2 * tone.g + 0.5)) / (tone.g * (6.2 * tone.g + 1.66) + 0.066);
	tone.b = (tone.b * (6.2 * tone.b + 0.5)) / (tone.b * (6.2 * tone.b + 1.66) + 0.066);

	const float gamma = 2.42;
	tone = EncodeGamma(tone, gamma);

	color = lerp(color, tone, GetOption(B_TONE_FAMOUNT));

	return color;
}

float4 TonemapPass(float4 color)
{
	float luminanceAverage = GetOption(E_LUMINANCE);
	float bmax = max(color.r, max(color.g, color.b));

	float blevel = pow(saturate(bmax), GetOption(C_BLACK_LEVELS));
	color.rgb = color.rgb * blevel;

	if (OptionEnabled(A_TONEMAP_FILM)) { color.rgb = FilmicTonemap(color.rgb); }
	if (OptionEnabled(A_TONEMAP_TYPE)) { color.rgb = FilmicCurve(color.rgb); }

	float3 XYZ = RGBtoXYZ(color.rgb);

	// XYZ -> Yxy conversion
	float3 Yxy = XYZtoYxy(XYZ);

	// (Wt) Tone mapped scaling of the initial wp before input modifiers
	float Wt = saturate(Yxy.r / AvgLuminance(XYZ));

	if (GetOption(A_TONEMAP_TYPE) == 2) { Yxy.r = FilmicCurve(Yxy).r; }

	// (Lp) Map average luminance to the middlegrey zone by scaling pixel luminance
	float Lp = Yxy.r * GetOption(D_EXPOSURE) / (luminanceAverage + Epsilon);

	// (Wp) White point calculated, based on the toned white, and input modifier
	float Wp = abs(Wt) * GetOption(F_WHITEPOINT);

	// (Ld) Scale all luminance within a displayable range of 0 to 1
	Yxy.r = (Lp * (1.0 + Lp / (Wp * Wp))) / (1.0 + Lp);

	// Yxy -> XYZ conversion
	XYZ = YxytoXYZ(Yxy);

	color.rgb = XYZtoRGB(XYZ);
	color.a = AvgLuminance(color.rgb);

	return color;
}


/*------------------------------------------------------------------------------
[PIXEL VIBRANCE CODE SECTION]
------------------------------------------------------------------------------*/

float4 VibrancePass(float4 color)
{
	float vib = GetOption(A_VIBRANCE);
	float luma = AvgLuminance(color.rgb);

	float colorMax = max(color.r, max(color.g, color.b));
	float colorMin = min(color.r, min(color.g, color.b));

	float colorSaturation = colorMax - colorMin;
	float3 colorCoeff = float3(GetOption(B_R_VIBRANCE)*
		vib, GetOption(C_G_VIBRANCE) * vib, GetOption(D_B_VIBRANCE) * vib);

	color.rgb = lerp(float3(luma, luma, luma), color.rgb, (1.0 + (colorCoeff * (1.0 - (sign(colorCoeff) * colorSaturation)))));
	color.a = AvgLuminance(color.rgb);

	return saturate(color); //Debug: return colorSaturation.xxxx;
}

/*------------------------------------------------------------------------------
[TEXTURE SHARPEN CODE SECTION]
------------------------------------------------------------------------------*/

float Cubic(float coeff)
{
	float4 n = float4(1.0, 2.0, 3.0, 4.0) - coeff;
	float4 s = n * n * n;

	float x = s.x;
	float y = s.y - 4.0 * s.x;
	float z = s.z - 4.0 * s.y + 6.0 * s.x;
	float w = 6.0 - x - y - z;

	return (x + y + z + w) / 4.0;
}

float4 SampleBicubic(float2 texcoord)
{
	float2 texSize = GetResolution();
	float texelSizeX = (1.0 / texSize.x) * GetOption(C_SHARPEN_BIAS);
	float texelSizeY = (1.0 / texSize.y) * GetOption(C_SHARPEN_BIAS);

	float4 nSum = float4(0.0, 0.0, 0.0, 0.0);
	float4 nDenom = float4(0.0, 0.0, 0.0, 0.0);

	float a = frac(texcoord.x * texSize.x);
	float b = frac(texcoord.y * texSize.y);

	int nX = int(texcoord.x * texSize.x);
	int nY = int(texcoord.y * texSize.y);

	float2 uvCoord = float2(float(nX) / texSize.x, float(nY) / texSize.y);

	for (int m = -1; m <= 2; m++) {
		for (int n = -1; n <= 2; n++) {

			float4 Samples = SampleLocation(uvCoord +
				float2(texelSizeX * float(m), texelSizeY * float(n)));

			float vc1 = Cubic(float(m) - a);
			float4 vecCoeff1 = float4(vc1, vc1, vc1, vc1);

			float vc2 = Cubic(-(float(n) - b));
			float4 vecCoeff2 = float4(vc2, vc2, vc2, vc2);

			nSum = nSum + (Samples * vecCoeff2 * vecCoeff1);
			nDenom = nDenom + (vecCoeff2 * vecCoeff1);
		}
	}

	return nSum / nDenom;
}

float4 TexSharpenPass(float4 color)
{
	float3 calcSharpen = lumCoeff * GetOption(A_SHARPEN_STRENGTH);

	float4 blurredColor = SampleBicubic(GetCoordinates());
	float3 sharpenedColor = (color.rgb - blurredColor.rgb);

	float sharpenLuma = dot(sharpenedColor, calcSharpen);
	sharpenLuma = clamp(sharpenLuma, -GetOption(B_SHARPEN_CLAMP), GetOption(B_SHARPEN_CLAMP));

	color.rgb = color.rgb + sharpenLuma;
	color.a = AvgLuminance(color.rgb);

	if (GetOption(D_SEDGE_DETECTION) == 1)
	{
		color = (0.5 + (sharpenLuma * 4)).xxxx;
	}

	return color;
}

void Merger()
{
	float4 value = float4(1.0, 1.0, 1.0, 1.0);
	if (GetOption(A_SSAO_ONLY) == 0)
	{
		value = Sample();
	}
#if A_SSAO_ENABLED != 0
	float4 blur = Bilateral(int2(0, 1), SampleDepth());
	value.rgb = (1 + blur.rgb) * blur.a * value.rgb;
#elif A_SSGI_ENABLED != 0
	float2 axis = float2(1, 0);
	float4 gi = PS_AO_Blur(axis);

	value.xyz = (gi.w + gi.xyz)*value.xyz;
	if (GetOption(A_AO_ONLY) == 1)
	{
		value = gi.wwww;
	}
	else if (GetOption(A_ILUMINATION_ONLY) == 1)
	{
		value = gi.xyzz;
	}
#endif
	if (OptionEnabled(G_TEXTURE_SHARPEN)) { value = TexSharpenPass(value); }
	if (OptionEnabled(H_PIXEL_VIBRANCE)) { value = VibrancePass(value); }
	if (OptionEnabled(C_TONEMAP_PASS)) { value = TonemapPass(value); }
	SetOutput(value);
}

//------------------------------------------------------------------------------
// BLOOM
//------------------------------------------------------------------------------

float4 Gauss1dPrev(float2 location, float2 baseoffset)
{
	const float offset[] = { 0, 1.4, 4459.0 / 1365.0, 539.0 / 105.0 };
	const float weight[] = { 0.20947265625, 0.30548095703125, 0.08331298828125, 0.00640869140625 };
	float4 Color = SamplePrevLocation(location) * weight[0];	
	baseoffset *= GetInvResolution() * 4.0 * GetOption(A_BLOOMWIDTH);
	for (int i = 1; i < 4; i++)
	{
		float4 color0 = SamplePrevLocation(location + offset[i] * baseoffset);
		float4 color1 = SamplePrevLocation(location - offset[i] * baseoffset);
		Color += (color0 + color1) * weight[i];
	}
	return Color;
}

void ReduceSize()
{
	float3 power = float3(1, 1, 1) * GetOption(B_BLOOMPOWER);
	float2 texcoord = GetCoordinates();
	float3 sceneLighting = SamplePrevLocation(texcoord + float2(-0.25, -0.25)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(0.0, -0.25)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(0.25, -0.25)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(-0.25, 0.0)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(0.25, 0.0)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(-0.25, 0.25)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(0.0, 0.25)).rgb;
	sceneLighting += SamplePrevLocation(texcoord + float2(0.25, 0.25)).rgb;
	sceneLighting *= 0.125;
	sceneLighting = (1.0 + (1.0 - GetOption(B_BLOOMINTENSITY)) * 7.0) * sceneLighting * sceneLighting;
	SetOutput(float4(pow(SamplePrev().rgb, power), dot(sceneLighting, lumCoeff)));
}

void BloomH()
{
	float2 texcoord = GetCoordinates();
	SetOutput(Gauss1dPrev(texcoord, float2(1.0, 0.0)));
}

void BloomV()
{
	float2 texcoord = GetCoordinates();
	SetOutput(Gauss1dPrev(texcoord, float2(0.0, 1.0)));
}

void BloomMerger()
{
	float4 blur = SamplePrev();
	SetOutput(float4(SamplePrev(1).rgb + (blur.rgb * (1.0 - blur.a)), 1.0));
}

//------------------------------------------------------------------------------
// Barrel Distortion
//------------------------------------------------------------------------------

float distortionScale(float2 offset) {
	// Note that this performs piecewise multiplication,
	// NOT a dot or cross product
	float2 offsetSquared = offset * offset;
	float radiusSquared = offsetSquared.x + offsetSquared.y;
	float4 distortion = GetOption(u_distortion);
	float distortionScale = //
		distortion.x + //
		distortion.y * radiusSquared + //
		distortion.z * radiusSquared * radiusSquared + //
		distortion.w * radiusSquared * radiusSquared * radiusSquared;
	return distortionScale;
}

float2 textureCoordsToDistortionOffsetCoords(float2 texCoord) {
	// Convert the texture coordinates from "0 to 1" to "-1 to 1"
	float2 result = texCoord * 2.0 - 1.0;

	// Convert from using the center of the screen as the origin to
	// using the lens center as the origin
	result -= GetOption(u_lensCenterOffset);

	// Correct for the aspect ratio
	result.y *= GetInvResolution().x * GetResolution().y;

	return result;
}

float2 distortionOffsetCoordsToTextureCoords(float2 offset) {
	// Scale the distorted result so that we fill the desired amount of pixel real-estate
	float2 result = offset;

	// Correct for the aspect ratio
	result.y *= GetInvResolution().y * GetResolution().x;

	// Convert from using the lens center as the origin to
	// using the screen center as the origin
	result += GetOption(u_lensCenterOffset);

	// Convert the texture coordinates from "-1 to 1" to "0 to 1"
	result *= 0.5;  result += 0.5;

	return result;
}

void Barrel_distortion(){
	// Grab the texture coordinate, which will be in the range 0-1 in both X and Y
	float2 offset = textureCoordsToDistortionOffsetCoords(FromSRCCoords(GetCoordinates()));

	// Determine the amount of distortion based on the distance from the lens center
	float scale = distortionScale(offset);

	// Scale the offset coordinate by the distortion factor introduced by the Rift lens
	float2 distortedOffset = offset * scale;

	// Now convert the data back into actual texture coordinates
	float2 actualTextureCoords = distortionOffsetCoordsToTextureCoords(distortedOffset);


	if (actualTextureCoords.x < 0 || actualTextureCoords.x > 1 || actualTextureCoords.y < 0 || actualTextureCoords.y > 1) 
	{
		SetOutput(float4(0,0,0,0));
	}
	else
	{
		SetOutput(SamplePrevLocation(ToSRCCoords(actualTextureCoords)));
	}
}

#define FXAA_REDUCE_MIN		(1.0/ 128.0)
#define FXAA_REDUCE_MUL		(1.0 / 8.0)
#define FXAA_SPAN_MAX		8.0


float4 applyFXAA(float2 fragCoord)
{
	float4 color;
	float2 inverseVP = GetInvResolution();
	float3 rgbNW = SamplePrevLocation((fragCoord + float2(-1.0, -1.0)) * inverseVP).xyz;
	float3 rgbNE = SamplePrevLocation((fragCoord + float2(1.0, -1.0)) * inverseVP).xyz;
	float3 rgbSW = SamplePrevLocation((fragCoord + float2(-1.0, 1.0)) * inverseVP).xyz;
	float3 rgbSE = SamplePrevLocation((fragCoord + float2(1.0, 1.0)) * inverseVP).xyz;
	float3 rgbM = SamplePrevLocation(fragCoord  * inverseVP).xyz;
	float3 luma = lumCoeff;
	float lumaNW = dot(rgbNW, luma);
	float lumaNE = dot(rgbNE, luma);
	float lumaSW = dot(rgbSW, luma);
	float lumaSE = dot(rgbSE, luma);
	float lumaM = dot(rgbM, luma);
	float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
	float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

	float2 dir;
	dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
	dir.y = ((lumaNW + lumaSW) - (lumaNE + lumaSE));

	float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *
		(0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);

	float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
	dir = min(float2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),
		max(float2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
		dir * rcpDirMin)) * inverseVP;

	float3 rgbA = 0.5 * (
		SamplePrevLocation(fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +
		SamplePrevLocation(fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);
	float3 rgbB = rgbA * 0.5 + 0.25 * (
		SamplePrevLocation(fragCoord * inverseVP + dir * -0.5).xyz +
		SamplePrevLocation(fragCoord * inverseVP + dir * 0.5).xyz);

	float lumaB = dot(rgbB, luma);
	if ((lumaB < lumaMin) || (lumaB > lumaMax))
		color = float4(rgbA, 1.0);
	else
		color = float4(rgbB, 1.0);
	return color;
}

void FXAAPS()
{
	SetOutput(applyFXAA(GetCoordinates() * GetResolution()));
}


