#extension GL_EXT_shader_framebuffer_fetch : require

//TODO: add blending by adding the framgmentColor varying
//varying vec4 v_fragmentColor;

void main(void)
{
	// Apples' values
	mediump float lum = dot(gl_LastFragData[0], vec4(0.30,0.59,0.11,0.0));
    
	gl_FragColor = vec4(lum, lum, lum, 1.0);
}