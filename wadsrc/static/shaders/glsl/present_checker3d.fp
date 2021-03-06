
in vec2 TexCoord;
out vec4 FragColor;

uniform sampler2D LeftEyeTexture;
uniform sampler2D RightEyeTexture;

vec4 ApplyGamma(vec4 c)
{
	vec3 val = c.rgb * Contrast - (Contrast - 1.0) * 0.5;
	val += Brightness * 0.5;
	val = pow(max(val, vec3(0.0)), vec3(InvGamma));
	return vec4(val, c.a);
}

void main()
{
	int thisVerticalPixel = int(gl_FragCoord.y); // Bottom row is typically the right eye, when WindowHeight is even
	int thisHorizontalPixel = int(gl_FragCoord.x); // column
	bool isLeftEye = (thisVerticalPixel // because we want to alternate eye view on each row
			+ thisHorizontalPixel // and each column
			+ WindowPositionParity // because the window might not be aligned to the screen
		) % 2 == 0;
	vec4 inputColor;
	if (isLeftEye) {
		inputColor = texture(LeftEyeTexture, TexCoord);
	}
	else {
		// inputColor = vec4(0, 1, 0, 1);
		inputColor = texture(RightEyeTexture, TexCoord);
	}
	FragColor = ApplyGamma(inputColor);
}
