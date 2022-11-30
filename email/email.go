package email

import (
	"fmt"
)

type EmailIdentity struct {
	Name  string
	Email string
}

type Email struct {
	From      EmailIdentity
	To        EmailIdentity
	Subject   string
	HTML      string
	PlainText string
}

func main() {
	fmt.Println("Hello World")
	email := SnapshotCreatedEmail("puskar@turbot.com", "https://steampipe.io/community/join?utm_id=ewelcomespc&utm_source=mandatory&utm_medium=email&utm_campaign=gettingstarted&utm_content=welcome")
	fmt.Println(email)
}

func SnapshotCreatedEmail(emailTo string, snapshotUrl string) Email {
	subject := "Created steampipe snapshot"
	fmt.Println("Snapshot url: ", snapshotUrl)
	html := fmt.Sprintf(`<div style="font-size:16px;line-height:26px;margin:0 auto;max-width:550px">
<!--Header-->
<div name="header" style="font-size:16px;line-height:26px;margin-bottom:16px;margin-top:0;padding-top:16px;text-align:center">
<figure style="display:inline-block;margin:0 auto;width:100&percnt;">
	<table width="100&percnt;" border="0" cellspacing="0" cellpadding="0" style="margin:8px auto">
		<tbody>
			<tr>
				<td style="text-align:center"></td>
				<td align="left" width="220" style="text-align:center">
						<img alt="" width="220" height="33" src="https://drive.google.com/uc?export=view&id=1mTwydBusIV2AyASSmtDrT2iSLpT60iXH" style="border:none!important;display:block;height:auto;margin:0 auto;margin-bottom:0;max-width:100&percnt;!important;vertical-align:middle;width:auto!important">
				</td>
				<td style="text-align:center"></td>
			</tr>
		</tbody>
	</table>
</figure>
</div>
<!--Body-->
<div dir="auto" style="font-size:16px;line-height:26px;margin-bottom:12px;text-align:initial;width:100&percnt;;word-break:break-word">
	<!--Paragraph with a url embedded into a word-->
	<p>
			Your CIS v1.4 dashboard snapshot has been created.
	</p>
	<!--Paragraph with a url embedded and bold words-->
	<p>
			Here's a quick summary:
	</p>
	<!--A simple paragraph with bold words included-->
	<p>
		<style>
* {
box-sizing: border-box;
}
body {
font-family: Arial, Helvetica, sans-serif;
}
/* Float five columns side by side */
.column {
float: left;
width: 20&percnt;;
padding: 0 10px;
}
/* Remove extra left and right margins, due to padding */
.row {margin: 0 -5px;}
/* Clear floats after the columns */
.row:after {
content: "";
display: table;
clear: both;
}
/* Responsive columns */
@media screen and (max-width: 600px) {
.column {
width: 100&percnt;;
display: block;
margin-bottom: 20px;
}
}
/* Style the counter cards */
.cardOK {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
padding: 4px;
text-align: center;
color: #FFFFFF;
background-color: #198038;
}
.cardAlarm {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
padding: 4px;
text-align: center;
color: #FFFFFF;
background-color: #da1e28;
}
.cardError {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
padding: 4px;
text-align: center;
color: #FFFFFF;
background-color: #e00;
}
.cardInfo {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
padding: 4px;
text-align: center;
color: #FFFFFF;
background-color: #3185fc;
}
.cardSkipped {
box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
padding: 4px;
text-align: center;
color: #000000;
background-color: fff;
}
</style>
		<div class="row">
<div class="column">
<div class="cardOK">
	<h4>OK</h4>
	<h3>21</h3>
</div>
</div>
<div class="column">
<div class="cardAlarm">
	<h4>Alarm</h4>
	<h3>21</h3>
</div>
</div>

<div class="column">
<div class="cardError">
	<h4>Error</h4>
	<h3>4</h3>
</div>
</div>

<div class="column">
<div class="cardInfo">
	<h4>Info</h4>
	<h3>7</h3>
</div>
</div>

<div class="column">
<div class="cardSkipped">
	<h4>Skipped</h4>
	<h3>0</h3>
</div>
</div>
</div>
	</p>
	<!--Paragraph with url embedded into multiple words-->
	<p>
	 →   <a href="%s"><em>View complete snapshot</em></a>
	</p>
	<!--Paragraph with a url embedded and bold words-->
	<p>
			We want to hear from you! We thrive on feedback and welcome any
		<br> suggestions &amp; comments in our&nbsp;<a href="https://steampipe.io/community/join?utm_id=ewelcomespc&utm_source=mandatory&utm_medium=email&utm_campaign=gettingstarted&utm_content=welcome">Slack community</a>&nbsp;<strong>#cloud</strong>&nbsp;channel.
	</p>
	<!--Section to include select thanks-->
	<p>
			<em>— select&nbsp;thanks&nbsp;from&nbsp;steampipe;</em>
	</p>
</div>
<!--Footer-->
<div style="color:rgb(128,128,128);padding:16px;text-align:center;background:rgb(245,245,245);font-size:12px;line-height:22px;">
<p style="margin:0px;">Turbot HQ, Inc.</p>
<p style="margin:0px;">1732 1st Ave #20232, New York, NY 10128, USA </p>
<p style="margin:0px;"> <a href="https://cloud.steampipe.io/user/{{userhandle}}/settings">Unsubscribe</a> </p>
</div>
</div>`, snapshotUrl)

	// 	html := fmt.Sprintf(`<div style="font-size:16px;line-height:26px;margin:0 auto;max-width:550px">
	// 	<!--Header-->
	// <div name="header" style="font-size:16px;line-height:26px;margin-bottom:16px;margin-top:0;padding-top:16px;text-align:center">
	// 	<figure style="display:inline-block;margin:0 auto;width:%s">
	// 		<table width="%s" border="0" cellspacing="0" cellpadding="0" style="margin:8px auto">
	// 			<tbody>
	// 				<tr>
	// 					<td style="text-align:center"></td>
	// 					<td align="left" width="220" style="text-align:center">
	// 							<img alt="" width="220" height="33" src="https://drive.google.com/uc?export=view&id=1mTwydBusIV2AyASSmtDrT2iSLpT60iXH" style="border:none!important;display:block;height:auto;margin:0 auto;margin-bottom:0;max-width:%s!important;vertical-align:middle;width:auto!important">
	// 					</td>
	// 					<td style="text-align:center"></td>
	// 				</tr>
	// 			</tbody>
	// 		</table>
	// 	</figure>
	// </div>
	// <!--Body-->
	// <div dir="auto" style="font-size:16px;line-height:26px;margin-bottom:12px;text-align:initial;width:%s;word-break:break-word">
	// 		<!--Paragraph with a url embedded into a word-->
	// 		<p>
	// 				Your CIS v1.4 dashboard snapshot has been created.
	// 		</p>
	// 		<!--Paragraph with a url embedded and bold words-->
	// 		<p>
	// 				Here's a quick summary:
	// 		</p>
	// 		<!--A simple paragraph with bold words included-->
	// 		<p>
	// 			<style>
	// * {
	// box-sizing: border-box;
	// }
	// body {
	// font-family: Arial, Helvetica, sans-serif;
	// }
	// /* Float five columns side by side */
	// .column {
	// float: left;
	// width: %s;
	// padding: 0 10px;
	// }
	// /* Remove extra left and right margins, due to padding */
	// .row {margin: 0 -5px;}
	// /* Clear floats after the columns */
	// .row:after {
	// content: "";
	// display: table;
	// clear: both;
	// }
	// /* Responsive columns */
	// @media screen and (max-width: 600px) {
	// .column {
	// 	width: %s;
	// 	display: block;
	// 	margin-bottom: 20px;
	// }
	// }
	// /* Style the counter cards */
	// .cardOK {
	// box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	// padding: 4px;
	// text-align: center;
	// color: #FFFFFF;
	// background-color: #198038;
	// }
	// .cardAlarm {
	// box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	// padding: 4px;
	// text-align: center;
	// color: #FFFFFF;
	// background-color: #da1e28;
	// }
	// .cardError {
	// box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	// padding: 4px;
	// text-align: center;
	// color: #FFFFFF;
	// background-color: #e00;
	// }
	// .cardInfo {
	// box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	// padding: 4px;
	// text-align: center;
	// color: #FFFFFF;
	// background-color: #3185fc;
	// }
	// .cardSkipped {
	// box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
	// padding: 4px;
	// text-align: center;
	// color: #000000;
	// background-color: fff;
	// }
	// </style>
	// 			<div class="row">
	// <div class="column">
	// 	<div class="cardOK">
	// 		<h4>OK</h4>
	// 		<h3>21</h3>
	// 	</div>
	// </div>
	// <div class="column">
	// 	<div class="cardAlarm">
	// 		<h4>Alarm</h4>
	// 		<h3>21</h3>
	// 	</div>
	// </div>

	// <div class="column">
	// 	<div class="cardError">
	// 		<h4>Error</h4>
	// 		<h3>4</h3>
	// 	</div>
	// </div>

	// <div class="column">
	// 	<div class="cardInfo">
	// 		<h4>Info</h4>
	// 		<h3>7</h3>
	// 	</div>
	// </div>

	// <div class="column">
	// 	<div class="cardSkipped">
	// 		<h4>Skipped</h4>
	// 		<h3>0</h3>
	// 	</div>
	// </div>
	// </div>
	// 		</p>
	// 		<!--Paragraph with url embedded into multiple words-->
	// 		<p>
	// 		 →   <a href="%s"><em>View complete snapshot</em></a>
	// 		</p>
	// 		<!--Paragraph with a url embedded and bold words-->
	// 		<p>
	// 				We want to hear from you! We thrive on feedback and welcome any
	// 			<br> suggestions &amp; comments in our&nbsp;<a href="https://steampipe.io/community/join?utm_id=ewelcomespc&utm_source=mandatory&utm_medium=email&utm_campaign=gettingstarted&utm_content=welcome">Slack community</a>&nbsp;<strong>#cloud</strong>&nbsp;channel.
	// 		</p>
	// 		<!--Section to include select thanks-->
	// 		<p>
	// 				<em>— select&nbsp;thanks&nbsp;from&nbsp;steampipe;</em>
	// 		</p>
	// </div>
	// <!--Footer-->
	// <div style="color:rgb(128,128,128);padding:16px;text-align:center;background:rgb(245,245,245);font-size:12px;line-height:22px;">
	// 	<p style="margin:0px;">Turbot HQ, Inc.</p>
	// 	<p style="margin:0px;">1732 1st Ave #20232, New York, NY 10128, USA </p>
	// 	<p style="margin:0px;"> <a href="https://cloud.steampipe.io/user/{{userhandle}}/settings">Unsubscribe</a> </p>
	// </div>
	// </div>`, "100%", "100%", "100%", "20%", "100%", "100%", snapshotUrl)
	email := Email{
		From: EmailIdentity{
			Name:  "Steampipe",
			Email: "system@steampipe.io",
		},
		To: EmailIdentity{
			Name:  emailTo,
			Email: emailTo,
		},
		Subject:   subject,
		HTML:      html,
		PlainText: subject,
	}
	return email
}
