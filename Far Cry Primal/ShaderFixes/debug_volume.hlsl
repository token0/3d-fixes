Texture3D<float> volume : register(t100);
Texture2DArray<float4> shadow : register(t101);
Texture1D<float4> IniParams : register(t120);

void main(float4 pos : SV_Position0, float4 spos: TEXCOORD0, float2 tpos: TEXCOORD1, out float4 result : SV_Target0)
{
	uint width, height, depth;
	volume.GetDimensions(width, height, depth);

	uint4 p = uint4(pos.xy, 0, 0);
	p.z = (uint)pos.y / height + (uint)pos.x / width * 16;
	p.x = pos.x % width;
	p.y = pos.y % height;
	result = volume.Load(p);
	//result.w = (p.z < depth) * (pos.x < width * 5) * 0.75;
	result.w = (p.z < depth) * 0.75;

	if (spos.x >= 0.5) {
		shadow.GetDimensions(width, height, depth);
		p.z = tpos.y * 3;
		p.x = spos.x * width * 2 % width;
		p.y = tpos.y * 3 * height - height * p.z;
		result = shadow.Load(p).x;
		result.w = (p.z < depth) * (p.x < width) * 0.85;
	}
}
