(*
 * IPWorks Encrypt 2022 Delphi Edition - Sample Project
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
 *)
unit smimef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ipcSmime, ipccore, ipctypes, ipccertmgr, certmgrf;

type
  TFormSmime = class(TForm)

    ipcCertMgr1: TipcCertMgr;
    ipcSmime1: TipcSMIME;
    Label1: TLabel;
    Label2: TLabel;
    mmoMessage: TMemo;
    mmoHeaders: TMemo;
    GroupBox1: TGroupBox;
    cmdSign: TButton;
    cmdEncrypt: TButton;
    cmdSignAndEncrypt: TButton;
    GroupBox2: TGroupBox;
    cmdDecrypt: TButton;
    cmdVerify: TButton;
    cmdDecryptAndVerify: TButton;

    procedure cmdEncryptClick(Sender: TObject);
    procedure cmdSignClick(Sender: TObject);
    procedure cmdSignAndEncryptClick(Sender: TObject);
    procedure cmdVerifyClick(Sender: TObject);
    procedure cmdDecryptClick(Sender: TObject);
    procedure cmdDecryptAndVerifyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSmime: TFormSmime;

implementation

{$R *.DFM}

procedure TFormSmime.cmdEncryptClick(Sender: TObject);
begin
        mmoHeaders.lines.Clear;
        ipcSmime1.Reset();
        ipcSmime1.InputMessage := mmoMessage.Text;

        FormCertmgr.lblCaption.Caption :='Please select the recipient certificate to encrypt the message with.';
        FormCertmgr.ShowModal;
        if SizeOf(FormCertmgr.ipcCertMgr1.CertSubject) > 0 then
        begin
        ipcSmime1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipcCertMgr1.CertEncoded));
        end;

    ipcSmime1.Encrypt;

    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

procedure TFormSmime.cmdSignClick(Sender: TObject);
begin
       mmoHeaders.lines.clear;
    ipcSmime1.Reset();
    ipcSmime1.InputMessage := mmoMessage.Text;

    FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
      'to sign the message with.' ;
    FormCertmgr.ShowModal ;
    if SizeOf(FormCertmgr.ipcCertMgr1.CertSubject) > 0 then
    begin
        ipcSmime1.CertStore := FormCertmgr.ipcCertMgr1.CertStore;
        ipcSmime1.CertSubject := FormCertmgr.ipcCertMgr1.CertSubject;
    End;

    ipcSmime1.DetachedSignature := True;
    ipcSmime1.IncludeCertificate := True;
    ipcSmime1.Sign;

    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

procedure TFormSmime.cmdSignAndEncryptClick(Sender: TObject);
begin
           mmoHeaders.lines.clear;
    ipcSmime1.Reset();
    ipcSmime1.InputMessage := mmoMessage.Text;

    FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
        'to sign the message with.';
    FormCertmgr.Showmodal;
    if SizeOf(FormCertmgr.ipcCertMgr1.CertSubject) > 0 then
    begin
        ipcSmime1.CertStore := FormCertmgr.ipcCertMgr1.CertStore;
        ipcSmime1.CertSubject := FormCertmgr.ipcCertMgr1.CertSubject;
    End;
    //Unload CertMgrServ

    ipcSmime1.DetachedSignature := True;
    ipcSmime1.IncludeCertificate := True;

    FormCertmgr.lblCaption.Caption := 'Please select the recipient ' +
        'certificate to encrypt the message with.';
    FormCertmgr.Showmodal;
    if SizeOf(FormCertmgr.ipcCertMgr1.CertSubject) > 0 then
    begin
        ipcSmime1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipcCertMgr1.CertEncoded));
    End;
    //Unload CertMgrServ

    ipcSmime1.SignAndEncrypt;

    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

procedure TFormSmime.cmdVerifyClick(Sender: TObject);
begin

    ipcSmime1.Reset();
    ipcSmime1.InputMessage := mmoMessage.Text;
    ipcSmime1.InputMessageHeadersString := mmoHeaders.Text;

    ipcSmime1.VerifySignature;

	MessageDlg('Subject: ' + ipcSmime1.SignerCertSubject + chr(13) +  chr(10) +
        'Issuer: ' + ipcSmime1.SignerCertIssuer + chr(13) + chr(10) +
        'Serial Number: ' + ipcSmime1.SignerCertSerialNumber,
        mtInformation, [mbOk], 0);
    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

procedure TFormSmime.cmdDecryptClick(Sender: TObject);
begin
    ipcSmime1.InputMessage := mmoMessage.Text;
    ipcSmime1.Decrypt;
    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

procedure TFormSmime.cmdDecryptAndVerifyClick(Sender: TObject);
begin
    ipcSmime1.InputMessage := mmoMessage.Text;
    ipcSmime1.DecryptAndVerifySignature;
    mmoMessage.Text := ipcSmime1.OutputMessage;
        
	MessageDlg('Subject: ' + ipcSmime1.SignerCertSubject + chr(13) +  chr(10) +
        'Issuer: ' + ipcSmime1.SignerCertIssuer + chr(13) + chr(10) +
        'Serial Number: ' + ipcSmime1.SignerCertSerialNumber,
        mtInformation, [mbOk], 0);
        
    mmoHeaders.Text := ipcSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipcSmime1.OutputMessage;
end;

end.

