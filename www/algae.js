<script type="text/javascript">
  $("#submit").on("click", function() {
    if($("#email").val()==""){
      $("#error").text("* Please enter your email!");
    };
  });
</script>