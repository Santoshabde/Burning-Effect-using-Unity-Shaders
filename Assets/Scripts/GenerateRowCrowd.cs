using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateRowCrowd : MonoBehaviour
{
    [SerializeField] private List<GameObject> crowdVariants;
    [SerializeField] private Transform parent;
    [SerializeField] private Transform startingPoint;
    [SerializeField] private int number;
    [SerializeField] private Vector3 spawnDiff;
    [SerializeField] private Vector3 initialOffset;

    public void GenerateCrowd()
    {
        Vector3 offsetIncrease = Vector3.zero;
        for (int i = 0; i < number; i++)
        {
            GameObject randomPickedCrowd = crowdVariants[Random.Range(0, crowdVariants.Count)];
            Instantiate(randomPickedCrowd, startingPoint.transform.position + offsetIncrease + spawnDiff, Quaternion.Euler(90,0,0)).transform.parent = parent;
            offsetIncrease += initialOffset;
        }
    }
}
