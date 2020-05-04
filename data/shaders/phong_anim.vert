#version 330
 
layout(location = 0) in vec3 a_vertex;
layout(location = 1) in vec2 a_uv;
layout(location = 2) in vec3 a_normal;
layout(location = 3) in vec4 a_vertex_weights; //weight for each of the joint ids
layout(location = 4) in vec4 a_vertex_jointids; //ids of joints that affect this vertex
 
// e.g. a_vertex_weights  [0.5, 0.2, 0.1, 0.2]
// e.g  a_vertex_jointids [3,   62,   1,   2]
 
const int MAX_JOINTS = 96;
uniform mat4 u_joint_pos_matrices[MAX_JOINTS];
uniform mat4 u_joint_bind_matrices[MAX_JOINTS];
 
//moves entire mesh into 'bind pose starting point'
uniform mat4 u_skin_bind_matrix; //same for every vertex
 
uniform mat4 u_mvp;
uniform mat4 u_vp;
uniform mat4 u_model;
uniform mat4 u_normal_matrix;
uniform vec3 u_cam_pos;
 
out vec2 v_uv;
out vec3 v_normal;
out vec3 v_vertex_world_pos;
out vec3 v_cam_dir;
 
void main(){
   
    //uvs
    v_uv = a_uv;
   
    //calculate direction to camera in world space
    v_cam_dir = u_cam_pos - v_vertex_world_pos;
   
    //unweighted position of vertex
    vec4 vertex4 = vec4(a_vertex, 1.0);
   
    //premultiply the vertex with the skin_bind_matrix
    vec4 vertex_bsm = u_skin_bind_matrix * vertex4;

    //normals are the same but with mat3
    vec3 normal3_bsm = mat3(u_skin_bind_matrix)* a_normal;
   
    //variables to store final position and normal
    vec4 final_vert = vec4(0.0);
    vec3 final_normal = vec3(0.0);
   
    //TODO: skeletal animation here
 
    for (int i = 0; i < 4; i++) {
       
        int j_id = int( a_vertex_jointids[i] );
       
        final_vert +=   a_vertex_weights[i] *
                        u_joint_pos_matrices[j_id] *
                        u_joint_bind_matrices[j_id] *
                        vertex_bsm;
        final_normal += a_vertex_weights[i] *
                    mat3(u_joint_pos_matrices[j_id]) *
                    mat3(u_joint_bind_matrices[j_id]) *
                    normal3_bsm;

    }
   
   
   // final_normal = (u_normal_matrix * vec4(a_normal, 1.0)).xyz;
   
    //set the final position and normal
    v_vertex_world_pos = final_vert.xyz;
    v_normal = final_normal;
   
 
    //output vertex to NDC
    gl_Position = u_vp * final_vert;
}
