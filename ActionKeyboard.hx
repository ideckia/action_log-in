using api.IdeckiaApi;

@:jsRequire("../keyboard", "IdeckiaAction")
extern class ActionKeyboard {
	function new();
	function setup(props:Any, core:IdeckiaCore):Any;
	function execute(state:ItemState):js.lib.Promise<ActionOutcome>;
}
