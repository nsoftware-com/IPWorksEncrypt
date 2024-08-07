/*
 * IPWorks Encrypt 2024 .NET Edition - Sample Project
 *
 * This sample project demonstrates the usage of IPWorks Encrypt in a 
 * simple, straightforward way. It is not intended to be a complete 
 * application. Error handling and other checks are simplified for clarity.
 *
 * www.nsoftware.com/ipworksencrypt
 *
 * This code is subject to the terms and conditions specified in the 
 * corresponding product license agreement which outlines the authorized 
 * usage and restrictions.
 * 
 */

﻿using System;
using nsoftware.IPWorksEncrypt;

class encryptDemo
{
  private static EzCrypt ezcrypt = new nsoftware.IPWorksEncrypt.EzCrypt();
  
  static void Main(string[] args)
  {
    if (args.Length < 8)
    {
      Console.WriteLine("usage: encrypt /a action /f inputfile /o outputfile [/w] /s inputstring /alg algorithm /p keypassword\n");
      Console.WriteLine("  /a action       chosen from {encrypt, decrypt}");
      Console.WriteLine("  /f inputfile    the path to the input file (specify this or inputstring, but not both)");
      Console.WriteLine("  /o outputfile   the path to the output file (specify if inputfile is specified)");
      Console.WriteLine("  /w              whether to overwrite the output file (optional)");
      Console.WriteLine("  /s inputstring  the message to encrypt or decrypt (if decrypt, must be in hex)");
      Console.WriteLine("  /alg algorithm  the symmetric encryption algorithm to use, chosen from");
      Console.WriteLine("                  {AES, Blowfish, CAST, ChaCha, DES, IDEA, RC2, RC4, Rijndael, TEA, TripleDES, Twofish, XSalsa20}");
      Console.WriteLine("  /p keypassword  the key password used to generate the Key and IV");
      Console.WriteLine("\nExample: encrypt /a encrypt /f c:\\myfile.txt /o c:\\myencryptedfile.dat /w /alg aes /p password\n");
    }
    else
    {
      System.Collections.Generic.Dictionary<string, string> myArgs = ConsoleDemo.ParseArgs(args);
      string action = myArgs["a"];

      SelectAlgorithm(myArgs["alg"]);

      if (!myArgs.ContainsKey("p")) throw new Exception("A password must be specified with the \"/p\" flag.\n");
      ezcrypt.KeyPassword = myArgs["p"];

      // Set up the encryption or decryption.
      if (myArgs.ContainsKey("f")) ezcrypt.InputFile = myArgs["f"];
      if (myArgs.ContainsKey("o")) ezcrypt.OutputFile = myArgs["o"];
      if (myArgs.ContainsKey("s")) ezcrypt.InputMessage = myArgs["s"];
      ezcrypt.Overwrite = myArgs.ContainsKey("w");
      ezcrypt.UseHex = true;

      // Perform the encryption or decryption.
      if (action.Equals("encrypt"))
      {
        ezcrypt.Encrypt();
      }
      else if (action.Equals("decrypt"))
      {
        ezcrypt.Decrypt();
      }
      else
      {
        throw new Exception("Invalid action.\n");
      }

      Console.WriteLine("Completed " + action + "ion!");
      if (myArgs.ContainsKey("o"))
      {
        Console.WriteLine("Output file: " + ezcrypt.OutputFile);
      }
      else
      {
        Console.WriteLine("Output message: " + ezcrypt.OutputMessage);
      }
    }
  }
  
  private static void SelectAlgorithm(string algo)
  {
    switch (algo.ToLower())
    {
      case "aes":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezAES;
        break;
      case "blowfish":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezBlowfish;
        break;
      case "cast":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezCAST;
        break;
      case "chacha":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezChaCha;
        break;
      case "des":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezDES;
        break;
      case "idea":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezIDEA;
        break;
      case "rc2":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezRC2;
        break;
      case "rc4":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezRC4;
        break;
      case "rijndael":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezRijndael;
        break;
      case "tea":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezTEA;
        break;
      case "tripledes":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezTripleDES;
        break;
      case "twofish":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezTwofish;
        break;
      case "xsalsa20":
        ezcrypt.Algorithm = EzCryptAlgorithms.ezXSalsa20;
        break;
      default:
        throw new Exception("Invalid algorithm selection.\n");
    }
  }
}




class ConsoleDemo
{
  /// <summary>
  /// Takes a list of switch arguments or name-value arguments and turns it into a dictionary.
  /// </summary>
  public static System.Collections.Generic.Dictionary<string, string> ParseArgs(string[] args)
  {
    System.Collections.Generic.Dictionary<string, string> dict = new System.Collections.Generic.Dictionary<string, string>();

    for (int i = 0; i < args.Length; i++)
    {
      // Add a key to the dictionary for each argument.
      if (args[i].StartsWith("/"))
      {
        // If the next argument does NOT start with a "/", then it is a value.
        if (i + 1 < args.Length && !args[i + 1].StartsWith("/"))
        {
          // Save the value and skip the next entry in the list of arguments.
          dict.Add(args[i].ToLower().TrimStart('/'), args[i + 1]);
          i++;
        }
        else
        {
          // If the next argument starts with a "/", then we assume the current one is a switch.
          dict.Add(args[i].ToLower().TrimStart('/'), "");
        }
      }
      else
      {
        // If the argument does not start with a "/", store the argument based on the index.
        dict.Add(i.ToString(), args[i].ToLower());
      }
    }
    return dict;
  }
  /// <summary>
  /// Asks for user input interactively and returns the string response.
  /// </summary>
  public static string Prompt(string prompt, string defaultVal)
  {
    Console.Write(prompt + (defaultVal.Length > 0 ? " [" + defaultVal + "]": "") + ": ");
    string val = Console.ReadLine();
    if (val.Length == 0) val = defaultVal;
    return val;
  }
}