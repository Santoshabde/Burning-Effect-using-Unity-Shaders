using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(GenerateRowCrowd))]
public class GenerateRowCrowd_Editor : Editor
{
    public override void OnInspectorGUI()
    {
        GenerateRowCrowd gen = (GenerateRowCrowd)target;

        base.OnInspectorGUI();

        if(GUILayout.Button("Generate"))
        {
            gen.GenerateCrowd();
        }         
    }
}
